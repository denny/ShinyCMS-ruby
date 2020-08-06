# frozen_string_literal: true

# ShinyCMS tasks for setting up a demo site

require 'dotenv/tasks'

# rails shiny:demo:load
# - resets the database
# - creates a super-admin
# - inserts the demo site data

# rails shiny:demo:dump
# - dumps the current database contents to db/demo_data.rb

# rubocop:disable Layout/MultilineArrayLineBreaks

# Big List of Models That Hold Demo Site Data
# TODO: FIXME: need to figure out how to handle plugin models here
MODEL_NAMES = %w[
  EmailRecipient MailingList Subscription
  Blog BlogPost NewsPost Discussion Comment
  PageTemplate PageTemplateElement PageSection Page PageElement InsertElement
  ShinyForms::Form
  Blazer::Query Blazer::Dashboard Blazer::DashboardQuery
].freeze

# rubocop:enable Layout/MultilineArrayLineBreaks

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
      Page.skip_callback( :create, :after, :add_elements )
      PageTemplate.skip_callback( :create, :after, :add_elements )
    end

    def set_callbacks_on_page_models
      PageTemplate.set_callback( :create, :after, :add_elements )
      Page.set_callback( :create, :after, :add_elements )
    end

    def fix_primary_key_sequences
      MODEL_NAMES.each do |model|
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
      MODEL_NAMES.each do |model|
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
    # :nocov:
  end
end
