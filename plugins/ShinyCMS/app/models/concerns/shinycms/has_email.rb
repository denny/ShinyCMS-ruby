# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for models that store email addresses
  module HasEmail
    extend ActiveSupport::Concern

    included do
      # Validations

      validates :email, presence: true, uniqueness: true
      validates :canonical_email, presence: true
      validates_with EmailAddress::ActiveRecordValidator, fields: %i[ email canonical_email ]

      # Before actions

      before_validation :strip_email, if: -> { email_changed? }
      before_validation :generate_canonical_email, if: -> { canonical_email.blank? || email_changed? }

      # Redact emails as part of deletion (to avoid naughty data retention if we only soft delete)
      before_destroy :redact_emails!

      # Instance methods

      def strip_email
        self.email = email.to_s.strip
      end

      def generate_canonical_email
        self.canonical_email = EmailAddress.canonical( email )
      end

      def ok_to_email?
        confirmed? && ShinyCMS::DoNotContact.not_listed?( email )
      end

      # TODO: make email address hard/non-standard to get at if marked not ok to email?
      def not_ok_to_email?
        !ok_to_email?
      end

      def obfuscated_email
        EmailAddress.munge( email )
      end

      def redact_emails!
        skip_reconfirmation! if is_a? User
        self.email = EmailAddress.redact( email )
        self.canonical_email = EmailAddress.redact( canonical_email )
        save!( validate: false )
      end

      # Returns a string suitable for use as the To: header in an email
      def email_to
        return email if name.blank?

        %("#{name}" <#{email}>)
      end
    end
  end
end
