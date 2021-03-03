# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# ShinyCMS admin user administration tasks

# rails shiny:admin:create - creates a new superadmin user, with full privs
# You can pass in details on the command line:
# rails shiny:admin:create username=admin password=nope email=you@example.com
# Otherwise, it will look for them in ENV and .env* files, or prompt for them

namespace :shiny do
  namespace :admin do
    desc 'ShinyCMS: create a new super-admin user (all capabilities enabled)'
    # :nocov:
    task create: %i[ environment dotenv get_admin_details ] do
      @shiny_admin.skip_confirmation!
      @shiny_admin.save!

      ShinyCMS::User.transaction do
        ShinyCMS::Capability.all.find_each do |capability|
          @shiny_admin.user_capabilities.create! capability: capability
        end
      end

      puts "ShinyCMS super-admin created; you can log in as '#{@shiny_admin.username}' now."
    end

    task get_admin_details: %i[ environment dotenv ] do
      username = ENV['username'] || ENV['SHINYCMS_ADMIN_USERNAME']
      password = ENV['password'] || ENV['SHINYCMS_ADMIN_PASSWORD']
      email    = ENV['email'   ] || ENV['SHINYCMS_ADMIN_EMAIL'   ]

      account_details = { username: username, password: password, email: email }

      admin = ShinyCMS::User.new( **account_details )
      admin.valid?

      admin, account_details = configure_username( admin, account_details )
      admin, account_details = configure_password( admin, account_details )

      @shiny_admin = configure_email( admin, account_details )
    end
    # :nocov:
  end
end

# :nocov:
def configure_username( admin, account_details )
  while admin.errors.messages.key? :username
    display_errors( 'username', admin.errors[ :username ] ) if account_details[ :username ].present?

    account_details[ :username ] = prompt_for_input( 'username' )

    admin = check_details( account_details )
  end
  [ admin, account_details ]
end

def configure_password( admin, account_details )
  while admin.errors.messages.key? :password
    display_errors( 'password', admin.errors[ :password ] ) if account_details[ :password ].present?

    account_details[ :password ] = prompt_for_input( 'password' )

    admin = check_details( account_details )
  end
  [ admin, account_details ]
end

def configure_email( admin, account_details )
  while admin.errors.messages.key? :email
    display_errors( 'email', admin.errors[ :email ] ) if account_details[ :email ].present?

    account_details[ :email ] = prompt_for_input( 'email address' )

    admin = check_details( account_details )
  end
  admin
end

def display_errors( attribute, errors )
  errors.each do |error|
    puts "#{attribute.capitalize}: #{error}"
  end
end

def prompt_for_input( attribute )
  puts "Please set the #{attribute} for your admin account:"
  $stdin.gets.strip
end

def check_details( account_details )
  admin = ShinyCMS::User.new( **account_details )
  admin.valid?
  admin
end
# :nocov:
