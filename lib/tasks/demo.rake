# frozen_string_literal: true

# ShinyCMS tasks for setting up a demo site

require 'dotenv/tasks'

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

      skip_callbacks_on_page_models
      require Rails.root.join 'db/demo_data.rb'
      set_callbacks_on_page_models

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

    def skip_callbacks_on_page_models
      ShinyPages::Page.skip_callback( :create, :after, :add_elements )
      ShinyPages::Template.skip_callback( :create, :after, :add_elements )
    end

    def set_callbacks_on_page_models
      ShinyPages::Template.set_callback( :create, :after, :add_elements )
      ShinyPages::Page.set_callback( :create, :after, :add_elements )
    end

    def fix_primary_key_sequences
      models_with_demo_data.each do |model|
        fix_primary_key_sequence( model.constantize.table_name )
      end
    end

    def fix_primary_key_sequence( table_name )
      ActiveRecord::Base.connection.execute(<<~SQL)
        BEGIN;
        LOCK TABLE #{table_name} IN EXCLUSIVE MODE;
        SELECT setval( '#{table_name}_id_seq', COALESCE( ( SELECT MAX(id)+1 FROM #{table_name} ), 1 ), false );
        COMMIT;
      SQL
    end

    task dump: %i[ environment dotenv ] do
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
      Rails.application.eager_load! if Rails.env.development?
      models = ApplicationRecord.models_with_demo_data

      # Fragile bodgery; move models with dependencies not happy with .sort order to the end
      models.delete( 'Comment' )
      models.delete( 'Discussion' )
      models.delete( 'ShinyPages::Page' )
      models.delete( 'ShinyPages::PageElement' )

      models.push( 'ShinyPages::Page', 'ShinyPages::PageElement', 'Discussion', 'Comment' )
    end
    # :nocov:
  end
end
