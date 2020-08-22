# frozen_string_literal: true

# Common behaviour for models that store email addresses
module ShinyEmail
  extend ActiveSupport::Concern

  included do
    validates :email, presence: true, uniqueness: true, case_sensitive: false
    validates :canonical_email, presence: true
    validates_with EmailAddress::ActiveRecordValidator, fields: %i[ email canonical_email ]

    # TODO: figure out how this interacts with Devise when user updates email
    before_validation :generate_canonical_email, if:
      -> { canonical_email.blank? || email_changed? }

    def generate_canonical_email
      self.canonical_email = EmailAddress.canonical( email )
    end
  end
end
