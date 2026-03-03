# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Code to create an admin user with the shinycms:admin:create rake task
module AdminUserTask
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
end
