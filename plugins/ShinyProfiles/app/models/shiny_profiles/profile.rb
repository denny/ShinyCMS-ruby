# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Model for user profile pages (and related features)
  class Profile < ApplicationRecord
    include ShinyCMS::CanHide
    include ShinyCMS::SoftDelete
    include ShinyCMS::WithUsers

    include ShinyCMS::ProvidesDemoSiteData
    include ShinyCMS::ProvidesSitemapData

    # Associations

    belongs_to :user, inverse_of: :profile, class_name: ShinyCMS.config_user_model

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
      user = user_with_username( username )
      raise ActiveRecord::RecordNotFound if user.blank?

      user.full_profile || create_profile!
      # (the latter in case the profiles feature was turned on after this user account was created)
    end

    def self.sitemap_items
      # TODO: let each user configure whether or not they consent to being fed into search engines
      visible.readonly.order( updated_at: :desc )
    end

    ## Integration with configured user model (ShinyCMS::User, by default)
    user_model = ShinyCMS.config_user_model

    # Add connection back from the user model to the profile model
    user_model.constantize.has_one :profile, inverse_of: :user, dependent: :destroy,
                                             class_name: 'ShinyProfiles::Profile'

    # Create a profile when creating a new user
    user_model.constantize.after_create :create_profile

    user_model.constantize.alias_method :original_name, :name
    user_model.constantize.remove_method :name

    # Override the name method, and add some extra getter methods (for more efficient db queries)
    module ExtendUserModel
      def name
        profile&.name || original_name
      end

      def profile_with_pic
        ShinyProfiles::Profile.with_pic.find_by( id: id )
      end

      def full_profile
        ShinyProfiles::Profile.with_links.with_pic.find_by( id: id )
      end
    end

    user_model.constantize.include ShinyProfiles::Profile::ExtendUserModel
  end
end
