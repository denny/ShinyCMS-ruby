# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'seed_dump'

module ShinyCMS
  # Code to import/export demo site data with the shinycms:demo:* rake tasks
  module DemoSiteTask
    DATA_FILE = ShinyCMS::Engine.root.join 'db/demo_site_data.rb'
    private_constant :DATA_FILE

    # Used by export task

    def models_with_demo_data
      core = ShinyCMS::Plugin.get( 'ShinyCMS' ).models_that_include( ShinyCMS::ProvidesDemoSiteData )
      features = ShinyCMS.plugins.models_that_include( ShinyCMS::ProvidesDemoSiteData )

      shinycms_models = [ core + features ].flatten.sort_by( &:name ).sort_by( &:demo_data_position )

      shinycms_models + other_models
    end

    def other_models
      [
        ActsAsTaggableOn::Tag,
        ActsAsTaggableOn::Tagging,

        ActiveStorage::Blob,
        ActiveStorage::VariantRecord,
        ActiveStorage::Attachment
      ]
    end

    # TODO: More of this code can be tested now that it's not buried in a rake task

    # :nocov:

    def create_statements_for( model )
      return '' if model.all.empty?

      Rails.logger.info "Dumping: #{model}"

      SeedDump.dump( model, exclude: %i[created_at updated_at tag_list hidden_tag_list] )
    end

    # This change means that `import_demo_data` can just require the dump file after
    # creating @shiny_admin, and all the imported content will belong to that user
    def munge_user_id_in( create_statements )
      create_statements.gsub 'user_id: 1', 'user_id: @shiny_admin.id'
    end

    private

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

    def write_demo_data_to_file( demo_data_sql )
      File.open( DATA_FILE, 'w' ) do |demo_data_file|
        demo_data_file.write demo_data_sql
      end
    end

    # Used by import task

    def prepare_admin_account_for_import( admin )
      admin.skip_confirmation!
      admin.save!

      grant_all_capabilities( admin )

      # Allow the demo data to replace @shiny_admin's user profile page
      admin.profile.destroy_fully!
    end

    def grant_all_capabilities( admin )
      ShinyCMS::User.transaction do
        ShinyCMS::Capability.find_each do |capability|
          admin.user_capabilities.create! capability: capability
        end
      end
    end

    def load_demo_site_data_file
      skip_callbacks_on_some_models

      require DATA_FILE

      set_callbacks_on_some_models

      fix_all_primary_key_sequences
    end

    # TODO: FIXME: Hardcoded model names, just say 'no'.
    def skip_callbacks_on_some_models
      ShinyNewsletters::Template.skip_callback :create, :after, :add_elements
      ShinyNewsletters::Edition.skip_callback  :create, :after, :add_elements
      ShinyPages::Template.skip_callback       :create, :after, :add_elements
      ShinyPages::Page.skip_callback           :create, :after, :add_elements
      ShinyCMS::Comment.skip_callback          :create, :after, :send_notifications
    end

    def set_callbacks_on_some_models
      ShinyNewsletters::Template.set_callback :create, :after, :add_elements
      ShinyNewsletters::Edition.set_callback  :create, :after, :add_elements
      ShinyPages::Template.set_callback       :create, :after, :add_elements
      ShinyPages::Page.set_callback           :create, :after, :add_elements
      ShinyCMS::Comment.set_callback          :create, :after, :send_notifications
    end

    def fix_all_primary_key_sequences
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
  end
end
