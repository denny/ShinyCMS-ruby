# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Model for access groups - part of the ShinyAccess plugin for ShinyCMS
  class Group < ApplicationRecord
    include ShinyCMS::HasPublicName
    include ShinyCMS::HasSlug
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    # Associations

    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships, inverse_of: :access_groups, class_name: ShinyCMS.config_user_model

    # Instance methods

    def member?( user )
      memberships.exists?( user: user )
    end

    def add_member( user )
      return false if member? user

      memberships.create( user: user ).persisted?
    end

    # Class methods

    def self.admin_search( query )
      where( 'internal_name ilike ?', "%#{query}%" )
        .or( where( 'public_name ilike ?', "%#{query}%" ) )
        .or( where( 'slug ilike ?', "%#{query}%" ) )
        .order( :internal_name )
    end

    # Integration with the configured user model
    user_model = ShinyCMS.config_user_model
    user_model.constantize.has_many :access_memberships, -> { active }, inverse_of: :user,
                                    dependent: :restrict_with_error, class_name: 'ShinyAccess::Membership'
    user_model.constantize.has_many :access_groups, through: :access_memberships, source: :group,
                                    inverse_of: :users, class_name: 'ShinyAccess::Group'
  end
end
