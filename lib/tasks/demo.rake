# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# ShinyCMS tasks for setting up a demo site

# rails shiny:demo:load
# - resets the database
# - creates a super-admin
# - inserts the demo site data

# rails shiny:demo:dump
# - dumps the current database contents to db/demo_data.rb

namespace :shiny do
  namespace :demo do
    desc 'ShinyCMS: reset database, create admin user, and load demo site data'
    # :nocov:
    prereqs = %i[
      environment dotenv confirm db:reset shiny:admin:get_admin_details
    ]
    task load: prereqs do
      @shiny_admin.skip_confirmation!
      @shiny_admin.save!
      @shiny_admin.grant_all_capabilities

      Setting.set :theme_name, to: 'halcyonic'

      skip_callbacks_on_templated_models
      require Rails.root.join 'db/demo_data.rb'
      set_callbacks_on_templated_models

      fix_primary_key_sequences

      FeatureFlag.enable :user_login

      puts 'Demo data loaded and admin account created.'
      puts "You can log in as '#{@shiny_admin.username}' now."
    end

    task confirm: %i[ environment dotenv ] do
      msg = 'Loading the demo site data wipes the database. Are you sure? (y/N)'
      $stdout.puts msg
      unless $stdin.gets.chomp.downcase.in? %w[ y yes ]
        puts 'Thank you. No action taken, database is unchanged.'
        exit
      end
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
        fix_primary_key_sequence( model.constantize.table_name )
      end
    end

    def fix_primary_key_sequence( table_name )
      ActiveRecord::Base.connection.execute(<<~SQL.squish)
        BEGIN;
        LOCK TABLE #{table_name} IN EXCLUSIVE MODE;
        SELECT setval( '#{table_name}_id_seq', COALESCE( ( SELECT MAX(id)+1 FROM #{table_name} ), 1 ), false );
        COMMIT;
      SQL
    end

    task dump: %i[ environment dotenv ] do
      Rails.application.eager_load!

      # FIXME: bodge to deal with collision between seed data and demo data
      ConsentVersion.find_by( slug: 'shiny-lists-admin-subscribe' )&.delete

      big_dump = ''
      models_with_demo_data.each do |model|
        puts "Dumping: #{model}"
        dump = SeedDump.dump(
          model.constantize, exclude: %i[created_at updated_at]
        )
        next unless dump # no data to dump

        big_dump = "#{big_dump}\n#{dump}"
      end
      result = big_dump.gsub 'user_id: 1', 'user_id: @shiny_admin.id'

      File.open( Rails.root.join( 'db/demo_data.rb' ), 'w' ) do |dump|
        dump.write result
      end
    end

    def models_with_demo_data
      models = ApplicationRecord.models_with_demo_data

      # Have to bodge load order here to fix dependency issues
      change_insert_order( models )
    end

    def change_insert_order( model_names )
      model_names = remove_models_from_list( model_names )
      add_models_to_end_of_list( model_names )
    end

    def models_to_reorder
      # FIXME: can the plugins provide a load order for their models?
      # rubocop:disable Layout/MultilineArrayLineBreaks
      %w[
        Discussion Comment
        ShinyPages::Page ShinyPages::PageElement
        ShinyNewsletters::Edition ShinyNewsletters::EditionElement ShinyNewsletters::Send
      ]
      # rubocop:enable Layout/MultilineArrayLineBreaks
    end

    def remove_models_from_list( model_names )
      models_to_reorder.each do |model_name|
        model_names.delete( model_name )
      end
      model_names
    end

    def add_models_to_end_of_list( model_names )
      model_names.push( *models_to_reorder )
    end
    # :nocov:
  end
end
