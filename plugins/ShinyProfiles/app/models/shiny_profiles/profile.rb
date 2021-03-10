# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Model for user profile pages (and related features)
  class Profile < ApplicationRecord
    include ShinyCMS::CanHide
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData
    include ShinyCMS::ProvidesSitemapData

    # Associations

    belongs_to :user, inverse_of: :profile, class_name: 'ShinyCMS::User'

    has_many :links, -> { order( :position ) }, inverse_of: :profile, dependent: :destroy

    accepts_nested_attributes_for :links, allow_destroy: true

    # User profile pic (powered by ActiveStorage)
    has_one_attached :profile_pic, dependent: :purge_now
    # The dependent: :purge_now option is required to avoid an incompatibility issue with soft delete:
    # https://github.com/ActsAsParanoid/acts_as_paranoid/issues/103

    scope :with_pic,   -> { includes( [ :profile_pic_attachment ] ) }
    scope :with_links, -> { includes( [ :links ] ) }

    # Validations

    validates :user, presence: true, uniqueness: true

    # Get username and email for Profile via the associated User model

    delegate :username, to: :user
    delegate :email,    to: :user

    # Plugins

    if ShinyCMS.plugins.loaded? :ShinySearch
      include ShinySearch::Searchable
      searchable_by :username, :public_name, :public_email, :bio, :location, :postcode
    end

    # Instance methods

    def name
      public_name.presence || username
    end

    def path
      url_helpers.profile_path username
    end

    # Class methods

    def self.for_username( username )
      user = ShinyCMS::User.find_by( username: username )
      raise ActiveRecord::RecordNotFound if user.blank?

      user.full_profile || create_profile!
      # (the latter in case the profiles feature was turned on after this user account was created)
    end

    def self.sitemap_items
      # TODO: let each user configure whether or not they consent to being fed into search engines
      visible.readonly.order( updated_at: :desc )
    end
  end
end

module ShinyCMS
  # Add Profile hooks to User model
  class User
    has_one :profile, inverse_of: :user, dependent: :destroy, class_name: 'ShinyProfiles::Profile'

    after_create :create_profile

    def profile_with_pic
      ShinyProfiles::Profile.with_pic.find_by( id: id )
    end

    def full_profile
      ShinyProfiles::Profile.with_links.with_pic.find_by( id: id )
    end
  end
end
