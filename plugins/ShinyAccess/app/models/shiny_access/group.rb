# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
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

    has_many :memberships
    has_many :users, through: :memberships, inverse_of: :access_groups, class_name: 'ShinyCMS::User'

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
      @groups = where( 'internal_name ilike ?', "%#{query}%" )
                .or( where( 'public_name ilike ?', "%#{query}%" ) )
                .or( where( 'slug ilike ?', "%#{query}%" ) )
                .order( :internal_name )
    end
  end
end

# Don't want to lose records of these without a bit of deliberate effort, in case they were paid memberships
ShinyCMS::User.has_many :access_memberships, -> { active }, inverse_of: :user,
                        dependent: :restrict_with_error, class_name: 'ShinyAccess::Membership'
ShinyCMS::User.has_many :access_groups, through: :access_memberships, source: :group, inverse_of: :users,
                        class_name: 'ShinyAccess::Group'
