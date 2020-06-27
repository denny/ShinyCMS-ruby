# frozen_string_literal: true

# Store details of people who have asked you not to contact them at all
# Uses EmailAddress.redact to store and search addresses via a one-way hash
class DoNotContact < ApplicationRecord
  # Validations

  validates :email, presence: true, uniqueness: true

  # Before/after actions

  before_save :redact_email

  # Class methods

  def self.include?( email )
    find_by( email: canonicalise_and_redact( email ) ) ? true : false
  end

  def self.includes?( email )
    include?( email )
  end

  def self.canonicalise_and_redact( email )
    new_email = EmailAddress.new( email )
    return email if new_email.redacted?

    EmailAddress.redact( new_email.canonical )
  end

  private

  def redact_email
    self.email = DoNotContact.canonicalise_and_redact( email )
  end
end
