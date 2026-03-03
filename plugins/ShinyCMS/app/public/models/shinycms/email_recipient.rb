# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Store details of people you send email to, who don't have a user account
  # e.g. newsletter subscribers, pseudonymous comment reply notifications
  class EmailRecipient < ApplicationRecord
    include ShinyCMS::HasEmail
    include ShinyCMS::HasToken
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    # Associations

    has_many :pseudonymous_authors, dependent: :nullify

    # Email stats (powered by Ahoy)
    has_many :messages, as: :user, dependent: :nullify, class_name: 'Ahoy::Message'

    # Scopes

    scope :confirmed, -> { where.not( confirmed_at: nil ) }

    # Before/after actions

    after_create :send_confirm_email
    before_destroy :redact_emails!

    # Instance methods

    def set_confirm_token
      update!(
        confirm_token:   SecureRandom.uuid,
        confirm_sent_at: Time.zone.now,
        confirmed_at:    nil
      )
    end

    def send_confirm_email
      set_confirm_token
      EmailRecipientMailer.with( recipient: self ).confirm.deliver_later
    end

    def confirm
      return false if confirm_expired?

      update!( confirmed_at: Time.zone.now, confirm_token: nil )
    end

    def confirmed?
      confirmed_at.present?
    end

    def confirm_expired?
      confirm_sent_at < self.class.confirm_token_valid_for.ago
    end

    # Class methods

    def self.confirm_token_valid_for
      # TODO: make this configurable
      7.days
    end

    def self.admin_search( search_term )
      where( 'email ilike ?', "%#{search_term}%" )
        .or( where( 'name ilike ?', "%#{search_term}%" ) )
        .order( updated_at: :desc )
    end
  end
end
