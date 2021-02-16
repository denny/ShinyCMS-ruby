# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for models that store email addresses
  module ShinyEmail
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
        self.email = email&.strip
      end

      def generate_canonical_email
        self.canonical_email = EmailAddress.canonical( email )
      end

      def do_not_email?
        !confirmed? || DoNotContact.include?( email )
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
