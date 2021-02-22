# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Model for user accounts
  # Most of the important stuff is in the two ShinyUserAuth* concerns
  class User < ApplicationRecord
    include ShinyUserAuthentication  # Devise
    include ShinyUserAuthorization   # Pundit

    include ShinyEmail
    include ShinySoftDelete
    include ShinyUserContent

    # Validations

    # Allowed characters for usernames: a-z A-Z 0-9 . _ -
    USERNAME_REGEX = %r{[a-zA-Z0-9][-_.a-zA-Z0-9]*}
    private_constant :USERNAME_REGEX
    ANCHORED_USERNAME_REGEX = %r{\A#{USERNAME_REGEX}\z}
    private_constant :ANCHORED_USERNAME_REGEX
    USERNAME_ROUTE_CONSTRAINT = { username: USERNAME_REGEX }.freeze
    public_constant :USERNAME_ROUTE_CONSTRAINT

    validates :username, presence: true, uniqueness: true
    validates :username, length: { maximum: 50 }
    validates :username, format: ANCHORED_USERNAME_REGEX

    # Instance methods

    def name
      # TODO: FIXME: eww.
      if  ShinyCMS.plugins.loaded?( :ShinyProfiles ) &&
          ShinyCMS::FeatureFlag.enabled?( :user_profiles ) &&
          respond_to?( :profile ) &&
          profile.present?

        return profile.name
      end

      username
    end

    # Class methods

    def self.admin_search( search_term )
      where( 'username ilike ?', "%#{search_term}%" )
        .or( where( 'email ilike ?', "%#{search_term}%" ) )
        .order( :username )
    end
  end
end
