# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Store details of people you send email to, who don't have a user account
# e.g. newsletter subscribers, pseudonymous comment reply notifications
class EmailRecipient < ApplicationRecord
  include ShinyDemoDataProvider
  include ShinyEmail
  include ShinyToken

  # Associations

  has_many :comment_authors, dependent: :nullify

  # Email stats (powered by Ahoy)
  has_many :messages, as: :user, dependent: :nullify, class_name: 'Ahoy::Message'

  # Scopes

  scope :confirmed, -> { where.not( confirmed_at: nil ) }

  # Instance methods

  after_create :send_confirm_email

  def set_confirm_token
    update!(
      confirm_token: SecureRandom.uuid,
      confirm_sent_at: Time.zone.now,
      confirmed_at: nil
    )
  end

  def send_confirm_email
    set_confirm_token
    EmailRecipientMailer.confirm( self )
  end

  def confirm
    return false if confirm_expired?

    update!( confirmed_at: Time.zone.now )
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
end
