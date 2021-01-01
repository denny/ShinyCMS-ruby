# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Concern for user authentication - powered by Devise
module ShinyUserAuthentication
  extend ActiveSupport::Concern

  included do
    # Enable basically every Devise module except :omniauthable (for now)
    devise :database_authenticatable, :registerable, :recoverable, :rememberable,
           :validatable, :confirmable, :lockable, :timeoutable, :trackable
    devise :pwned_password unless Rails.env.test?

    # Virtual attribute/accessors to enable authenticating by either username or email
    def login
      @login || username || email
    end

    attr_writer :login

    # Instance methods

    # Queue email sends
    def send_devise_notification( notification, *args )
      devise_mailer.public_send( notification, self, *args ).deliver_later
    end

    # Class methods

    # Override find method to search by username as well as email
    def self.find_first_by_auth_conditions( warden_conditions )
      conditions = warden_conditions.dup
      login = conditions.delete( :login )
      if login
        where_clause = 'lower( username ) = :value OR lower( email ) = :value'
        where( conditions ).find_by( [ where_clause, { value: login.downcase } ] )
      elsif conditions[ :username ].nil?
        find_by( conditions )
      else
        find_by( username: conditions[ :username ] )
      end
    end
  end
end
