# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Model for tracking memberships of access groups - part of the ShinyAccess plugin for ShinyCMS
  class Membership < ApplicationRecord
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    # Associations

    belongs_to :group, inverse_of: :memberships
    belongs_to :user,  inverse_of: :access_memberships, class_name: ShinyCMS.config_user_model

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

    def self.admin_search( query )
      # TODO: search memberships by member's username/name/email/etc
      return search_date_range(  query ) if query.match? %r{\d\d\d\d-\d\d-\d\d\s+(-|to)\s+\d\d\d\d-\d\d-\d\d}
      return search_single_date( query ) if query.match? %r{\d\d\d\d-\d\d-\d\d}
    end

    def self.search_date_range( query )
      date1, date2 = start_and_end_dates_from_string( query )

      where( began_at: date1.beginning_of_day..date2.end_of_day )
        .or( where( ended_at: date1.beginning_of_day..date2.end_of_day ) )
    end

    def self.search_single_date( query )
      searched_date = Time.zone.parse( query )

      where( began_at: searched_date.all_day ).or( where( ended_at: searched_date.all_day ) )
    end

    def self.start_and_end_dates_from_string( string )
      dates = string.split %r{\s+(-|to)\s+}
      [ Time.zone.parse( dates.first ), Time.zone.parse( dates.third ) ]
    end

    private

    def set_began_at
      self.began_at = Time.zone.now.iso8601
    end
  end
end
