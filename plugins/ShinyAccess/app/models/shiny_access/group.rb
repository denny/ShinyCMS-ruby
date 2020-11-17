# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Model for access groups - part of the ShinyAccess plugin for ShinyCMS
  class Group < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyName
    include ShinySlug
    include ShinySoftDelete

    # Associations

    has_many :memberships
    has_many :users, through: :memberships, inverse_of: :access_groups

    # Instance methods

    def member?( user )
      memberships.exists?( user: user )
    end

    def add_member( user )
      return false if member? user

      memberships.create( user: user ).persisted?
    end
  end
end

# Don't want to lose records of these without a bit of deliberate effort, in case they were paid memberships
User.has_many :access_memberships, -> { active }, class_name: 'ShinyAccess::Membership', dependent: :restrict_with_error
User.has_many :access_groups, through: :access_memberships, source: :group,
                              class_name: 'ShinyAccess::Group', inverse_of: :users
