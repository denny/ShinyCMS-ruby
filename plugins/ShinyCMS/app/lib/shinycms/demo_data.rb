# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Import/export demo site data
  module DemoData
    DEMO_SITE_DATA_FILE = Rails.root.join 'db/demo_site_data.rb'
    private_constant :DEMO_SITE_DATA_FILE

    # :nocov: TODO: Most of this can be tested now!

    def import_demo_data( admin_user: )
      prepare_admin_account_for_import( admin_user )

      ShinyCMS::Setting.set :theme_name, to: 'halcyonic'

      load_demo_site_data_file

      ShinyCMS::FeatureFlag.enable :user_login
    end

    def export_demo_data
      prepare_for_export

      create_statements = create_statements_for_all( models_with_demo_data )

      demo_data = munge_user_id( create_statements )

      write_demo_data_to_file( demo_data )
    end

    private

    # Import

    def prepare_admin_account_for_import( admin )
      admin.skip_confirmation!
      admin.save!

      grant_all_capabilities( admin )

      # Allow the demo data to replace @shiny_admin's user profile page
      admin.profile.destroy_fully!
    end

    def grant_all_capabilities( admin )
      ShinyCMS::User.transaction do
        ShinyCMS::Capability.all.find_each do |capability|
          admin.user_capabilities.create! capability: capability
        end
      end
    end

    def load_demo_site_data_file
      skip_callbacks_on_templated_models

      require DEMO_SITE_DATA_FILE

      set_callbacks_on_templated_models

      fix_primary_key_sequences
    end

    def skip_callbacks_on_templated_models
      ShinyPages::Page.skip_callback( :create, :after, :add_elements )
      ShinyPages::Template.skip_callback( :create, :after, :add_elements )
      ShinyNewsletters::Edition.skip_callback( :create, :after, :add_elements )
      ShinyNewsletters::Template.skip_callback( :create, :after, :add_elements )
    end

    def set_callbacks_on_templated_models
      ShinyPages::Template.set_callback( :create, :after, :add_elements )
      ShinyPages::Page.set_callback( :create, :after, :add_elements )
      ShinyNewsletters::Template.set_callback( :create, :after, :add_elements )
      ShinyNewsletters::Edition.set_callback( :create, :after, :add_elements )
    end

    def fix_primary_key_sequences
      models_with_demo_data.each do |model|
        fix_primary_key_sequence( model.table_name )
      end
    end

    def fix_primary_key_sequence( table_name )
      ActiveRecord::Base.connection.execute( <<~SQL.squish )
        BEGIN;
        LOCK TABLE #{table_name} IN EXCLUSIVE MODE;
        SELECT setval( '#{table_name}_id_seq', COALESCE( ( SELECT MAX(id)+1 FROM #{table_name} ), 1 ), false );
        COMMIT;
      SQL
    end

    # Export

    def prepare_for_export
      # We need all the models pre-loaded so we can find those offering demo data
      Rails.application.eager_load!

      # Avoid collision between seed data and demo data
      ShinyCMS::ConsentVersion.find_by( slug: 'shiny-lists-admin-subscribe' )&.destroy_fully!
    end

    def create_statements_for_all( models )
      create_statements = ''
      models.each do |model|
        create_statements += create_statements_for( model )
      end
      create_statements
    end

    def create_statements_for( model )
      return '' if model.all.size.zero?

      Rails.logger.info "Dumping: #{model}"

      SeedDump.dump( model, exclude: %i[created_at updated_at tag_list hidden_tag_list] )
    end

    def write_demo_data_to_file( demo_data_sql )
      File.open( DEMO_SITE_DATA_FILE, 'w' ) do |demo_data_file|
        demo_data_file.write demo_data_sql
      end
    end

    # This change means that `import_demo_data` can just require the dump file after
    # creating @shiny_admin, and all the imported content will belong to that user
    def munge_user_id( create_statements )
      create_statements.gsub 'user_id: 1', 'user_id: @shiny_admin.id'
    end

    def models_with_demo_data
      core_plugin_models = ShinyCMS::Plugin.get( 'ShinyCMS' ).models_with_demo_data
      feature_plugin_models = ShinyCMS.plugins.models_with_demo_data

      shinycms_models = [ core_plugin_models + feature_plugin_models ]
                        .flatten.sort_by( &:name ).sort_by( &:demo_data_position )

      shinycms_models + other_models
    end

    def other_models
      [
        ActsAsTaggableOn::Tag,
        ActsAsTaggableOn::Tagging,

        ActiveStorage::Blob,
        ActiveStorage::Attachment
      ]
    end
  end
end
