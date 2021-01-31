# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Explicitly require the main app User model here, to fix reloader glitches in dev env
require_dependency 'user'

module ShinyProfiles
  # Model for user profile pages (and related features)
  class Profile < ApplicationRecord
    include ShinySearch::Searchable if ShinyPlugin.loaded? :ShinySearch
    include ShinyDemoDataProvider
    include ShinyShowHide
    include ShinySoftDelete

    # Associations

    belongs_to :user

    has_many :links, -> { order( :position ) }, inverse_of: :profile, dependent: :destroy

    accepts_nested_attributes_for :links, allow_destroy: true

    # User profile pic (powered by ActiveStorage)
    has_one_attached :profile_pic, dependent: :purge_now
    # The dependent: :purge_now option is required to avoid an incompatibility issue with soft delete:
    # https://github.com/ActsAsParanoid/acts_as_paranoid/issues/103

    # Validations

    validates :user, presence: true, uniqueness: true

    # Get username and email for Profile via the associated User model

    delegate :username, to: :user
    delegate :email,    to: :user

    # Plugins

    searchable_by :username, :public_name, :public_email, :bio, :location, :postcode if ShinyPlugin.loaded? :ShinySearch

    # Instance methods

    def name
      public_name.presence || username
    end

    def path
      url_helpers.profile_path username
    end

    # Class methods

    def self.for_username( username )
      user = ::User.find_by( username: username )
      raise ActiveRecord::RecordNotFound if user.blank?

      profile = find_by( user: user )
      # TODO: Create profile if blank? (in case ShinyProfiles enabled after account created)
      raise ActiveRecord::RecordNotFound if profile.blank?

      profile
    end

    def self.sitemap_items
      visible.readonly
    end
  end
end

::User.has_one :profile, inverse_of: :user, class_name: 'ShinyProfiles::Profile', dependent: :destroy

::User.after_create :create_profile
