# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# ShinyCMS tasks for importing/exporting the data for the demo site

# rails shiny:demo:load
# - resets the database
# - creates a super-admin
# - imports the demo site data from ShinyCMS::DemoData::DEMO_SITE_DATA_FILE

# rails shiny:demo:export
# - exports the current database contents to DEMO_SITE_DATA_FILE

# Most of the import/export code for the demo site data is in this module:
require_relative '../../plugins/ShinyCMS/app/lib/shinycms/demo_site_data'

namespace :shiny do
  namespace :demo do
    include ShinyCMS::DemoSiteData

    prereqs = %i[ environment dotenv confirm db:reset shiny:admin:get_admin_details ]

    desc 'ShinyCMS: reset database, create admin user, and load demo site data'
    task load: prereqs do
      # :nocov:
      prepare_admin_account_for_import( @shiny_admin )

      ShinyCMS::Setting.set :theme_name, to: 'halcyonic'

      load_demo_site_data_file

      ShinyCMS::FeatureFlag.enable :user_login

      puts 'Demo data loaded and admin account created.'
      puts "You can log in as '#{@shiny_admin.username}' now."
      # :nocov:
    end

    task confirm: %i[ environment dotenv ] do
      # :nocov:
      msg = 'Loading the demo site data wipes the database. Are you sure? (y/N) '

      $stdout.print msg

      unless $stdin.gets.chomp.downcase.in? %w[ y yes ]
        puts 'Thank you. No action taken, database is unchanged.'
        exit
      end
      # :nocov:
    end

    task export: %i[ environment dotenv ] do
      # :nocov:
      prepare_for_export

      create_statements = create_statements_for_all( models_with_demo_data )

      demo_data = munge_user_id( create_statements )

      write_demo_data_to_file( demo_data )
      # :nocov:
    end
  end
end
