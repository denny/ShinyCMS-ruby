# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
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

      # Writer
      def login=( login_value )
        @login = login_value
      end

      # Queue email sends
      def send_devise_notification( notification, *args )
        devise_mailer.public_send( notification, self, *args ).deliver_later
      end

      # This blows up if I put it inside a 'class_methods do' block...

      # Override find method to search by username as well as email
      def self.find_first_by_auth_conditions( warden_conditions )
        conditions = warden_conditions.dup
        login = conditions.delete( :login )
        if login
          where_clause = 'lower( username ) = :value OR lower( email ) = :value'
          where( conditions ).find_by( [ where_clause, { value: login.downcase } ] )
        elsif conditions[ :username ].present?
          find_by( username: conditions[ :username ] )
        else
          find_by( conditions )
        end
      end
    end
  end
end
