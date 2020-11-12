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

    # Associations

    has_many :memberships

    # Instance methods

    def member?( user )
      memberships.exists?( user: user )
    end

    def add_member( user_id )
      return false unless User.exists? id: user_id

      memberships.create! user_id: user_id
    end
  end
end
