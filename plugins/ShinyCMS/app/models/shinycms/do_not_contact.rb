# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Store details of people who have asked you not to contact them at all
  # Uses EmailAddress.redact to store and search addresses via a one-way hash
  class DoNotContact < ApplicationRecord
    include ShinyCMS::SoftDelete

    # Validations

    validates :email, presence: true, uniqueness: true

    # Before/after actions

    before_validation :strip_email, if: -> { email_changed? }
    before_save :redact_email

    # Class methods

    def self.add( email_to_add )
      return unless EmailAddress.valid?( email_to_add )

      return :duplicate if listed? email_to_add
      return :success   if create!( email: email_to_add )
    end

    def self.listed?( email_to_check )
      exists? email: canonicalise_and_redact( email_to_check )
    end

    def self.not_listed?( email_to_check )
      !listed? email_to_check
    end

    def self.canonicalise_and_redact( email_to_redact )
      email_validator = EmailAddress.new( email_to_redact )
      return email_to_redact if email_validator.redacted?

      EmailAddress.redact( email_validator.canonical )
    end

    private

    def strip_email
      self.email = email.to_s.strip
    end

    def redact_email
      self.email = DoNotContact.canonicalise_and_redact( email )
    end
  end
end
