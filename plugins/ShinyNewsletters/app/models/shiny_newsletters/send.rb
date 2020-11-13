# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Model for newsletter sends - when an edition is sent to a list
  class Send < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyPaging
    include ShinySoftDelete

    # Associations

    belongs_to :edition
    belongs_to :list, class_name: 'ShinyLists::List'

    # Attributes and aliases

    attr_writer :send_at_time

    alias_attribute :sent_at, :finished_sending_at

    # Scopes

    scope :unscheduled, -> { where( started_sending_at: nil, send_at: nil ) }
    scope :scheduled,   -> { where( started_sending_at: nil ).where.not( send_at: nil ) }
    scope :due_to_send, -> { where( started_sending_at: nil ).where( 'send_at < ?', Time.zone.now ) }

    scope :sending, -> { where.not( started_sending_at: nil ).where( sent_at: nil ) }
    scope :sent,    -> { where.not( sent_at: nil ) }

    scope :recent, -> { order( sent_at: :desc ) }

    scope :sent_in_month, ->( year, month ) { where( sent_at: Date.new( year, month, 1 ).end_of_day.all_month ) }

    # Instance methods

    def send_at_time
      send_at&.time
    end

    def sent?
      finished_sending_at.present?
    end

    def sending?
      started_sending_at.present? && finished_sending_at.blank?
    end

    def scheduled?
      send_at.present? && started_sending_at.blank?
    end

    def future_dated?
      scheduled? && send_at > Time.zone.now
    end

    def start_sending
      SendToListJob.perform_later( self )
    end

    def cancel_sending
      # TODO: Distinguish between 'cancelled' and 'finished'
      update!( finished_sending_at: Time.zone.now )
    end

    def sent_month
      sent_at.strftime( '%m' )
    end

    def sent_year
      sent_at.strftime( '%Y' )
    end

    def path( token: nil )
      return url_helpers.token_view_newsletter_path( sent_year, sent_month, edition.slug, token ) if token.present?

      url_helpers.user_view_newsletter_path( sent_year, sent_month, edition.slug )
    end
  end
end

ShinyLists::List.has_many :newsletter_sends, inverse_of: :list, dependent: :restrict_with_error,
                                             class_name: 'ShinyNewsletters::Send'
