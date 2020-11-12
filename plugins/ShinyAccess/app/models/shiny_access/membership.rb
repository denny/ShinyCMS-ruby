# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Model for tracking memberships of access groups - part of the ShinyAccess plugin for ShinyCMS
  class Membership < ApplicationRecord
    include ShinyDemoDataProvider

    # Associations

    belongs_to :group
    belongs_to :user

    # Validations

    validates :group,    presence: true
    validates :user,     presence: true
    validates :began_at, presence: true

    # Scopes

    scope :active, -> { where( ended_at: nil ) }

    scope :active_first, -> { order( Arel.sql( 'ended_at is null' ) ) }
    scope :recent,       -> { order( began_at: :desc ) }

    # Set default timestamp if necessary

    before_validation :set_began_at, if: -> { began_at.blank? }

    # Instance methods

    def active?
      ended_at.blank?
    end

    def end
      return false unless active?

      update!( ended_at: Time.zone.now.iso8601 )
    end

    private

    def set_began_at
      self.began_at = Time.zone.now.iso8601
    end
  end
end
