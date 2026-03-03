# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

require_relative 'support/demo_site_task'

# ShinyCMS tasks for importing/exporting the data for the demo site

# rails shinycms:demo:load
# - resets the database
# - creates a super-admin
# - imports the demo site data from DemoSiteTask::DATA_FILE

# rails shinycms:demo:export
# - exports the current database contents to DemoSiteTask::DATA_FILE

namespace :shinycms do
  namespace :demo do
    include ShinyCMS::DemoSiteTask

    desc 'ShinyCMS: reset database, create admin user, and load demo site data'
    task load: %i[ environment dotenv confirm db:reset shinycms:admin:get_admin_details ] do
      # :nocov:
      prepare_admin_account_for_import( @shiny_admin )

      ShinyCMS::Setting.set :theme_name, to: 'halcyonic'
      ShinyCMS::AnonymousAuthor.create! if ShinyCMS::AnonymousAuthor.first.blank?

      load_demo_site_data_file

      ShinyCMS::FeatureFlag.enable :user_login

      puts 'Loaded demo site data and created admin account.'
      puts "You can log in as '#{@shiny_admin.username}' now."
      # :nocov:
    end

    task confirm: %i[ environment dotenv ] do
      # :nocov:
      $stdout.print 'Loading the demo site data wipes the database. Are you sure? (y/N) '

      unless $stdin.gets.chomp.downcase.in? %w[ y yes ]
        puts 'Thank you. No action taken, database is unchanged.'
        exit
      end
      # :nocov:
    end

    task export: %i[ environment dotenv ] do
      # :nocov:
      prepare_for_export

      demo_data = munge_user_id_in create_statements_for_all models_with_demo_data

      write_demo_data_to_file( demo_data )
      # :nocov:
    end
  end
end
