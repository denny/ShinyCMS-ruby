# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# ShinyCMS tasks for setting up a demo site

# rails shiny:demo:load
# - resets the database
# - creates a super-admin
# - imports the demo site data

# rails shiny:demo:export
# - exports the current database contents to db/demo_site_data.rb

# Most of the import/export code for the demo site data is in this module:
require_relative '../../plugins/ShinyCMS/app/lib/shinycms/demo_data'

namespace :shiny do
  namespace :demo do
    include ShinyCMS::DemoData

    prereqs = %i[ environment dotenv confirm db:reset shiny:admin:get_admin_details ]

    desc 'ShinyCMS: reset database, create admin user, and load demo site data'
    task load: prereqs do
      # :nocov:
      import_demo_data( admin_user: @shiny_admin )

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
      export_demo_data
      # :nocov:
    end
  end
end
