# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Model for user accounts
  # Most of the important stuff is in the two ShinyUserAuth* concerns
  class User < ApplicationRecord
    include ShinyUserAuthentication  # Devise
    include ShinyUserAuthorization   # Pundit
    include ShinyUserContent

    include ShinyCMS::HasEmail
    include ShinyCMS::SoftDelete

    # Validations

    validates :username, presence: true, uniqueness: true
    validates :username, length: { maximum: 50 }
    validates :username, format: ShinyCMS::UsernameValidation::ANCHORED_REGEX

    # Scopes

    scope :with_profiles, -> { includes( [ :profile ] ) }

    # Instance methods

    def name
      username
    end

    def url; end

    # Class methods

    def self.admin_search( search_term )
      where( 'username ilike ?', "%#{search_term}%" )
        .or( where( 'email ilike ?', "%#{search_term}%" ) )
        .order( :username )
    end
  end
end
