# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

require_relative 'support/admin_user_task'

# ShinyCMS admin user administration tasks

# Usage:
#   rails shinycms:admin:create
#   rails shinycms:admin:create username=admin password=Hunter2 email=you@example.com
#   SHINYCMS_ADMIN_USERNAME=root rails shinycms:admin:create
#
# Creates a new superadmin user, with all capabilities enabled. The username,
# password, and email for the new admin account can be specified in the command
# line options, or in ENV, or entered interactively (in order of precedence).

namespace :shinycms do
  namespace :admin do
    include AdminUserTask

    desc 'ShinyCMS: create a new super-admin user (all capabilities enabled)'
    task create: %i[ environment dotenv get_admin_details ] do
      # :nocov:
      @shiny_admin.skip_confirmation!
      @shiny_admin.save!

      ShinyCMS::User.transaction do
        ShinyCMS::Capability.find_each do |capability|
          @shiny_admin.user_capabilities.create! capability: capability
        end
      end

      puts "ShinyCMS super-admin created; you can log in as '#{@shiny_admin.username}' now."
      # :nocov:
    end

    task get_admin_details: %i[ environment dotenv ] do
      # :nocov:
      username = ENV['username'] || ENV['SHINYCMS_ADMIN_USERNAME']
      password = ENV['password'] || ENV['SHINYCMS_ADMIN_PASSWORD']
      email    = ENV['email'   ] || ENV['SHINYCMS_ADMIN_EMAIL'   ]

      account_details = { username: username, password: password, email: email }

      admin = ShinyCMS::User.new( **account_details )
      admin.valid?

      admin, account_details = configure_username( admin, account_details )
      admin, account_details = configure_password( admin, account_details )

      @shiny_admin = configure_email( admin, account_details )
      # :nocov:
    end
  end
end
