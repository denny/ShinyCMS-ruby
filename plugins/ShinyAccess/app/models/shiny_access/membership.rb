# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Model for tracking memberships of access groups - part of the ShinyAccess plugin for ShinyCMS
  class Membership < ApplicationRecord
    # Scopes

    scope :active, -> { where( ended_at: nil ) }

    scope :active_first, -> { order( Arel.sql( 'ended_at is null' ) ) }
    scope :recent,       -> { order( began_at: :desc ) }

    # Instance methods

    def cancel!
      update!( ended_at: Time.zone.now.iso8601 )
    end
  end
end
