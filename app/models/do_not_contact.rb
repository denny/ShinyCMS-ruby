# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Store details of people who have asked you not to contact them at all
# Uses EmailAddress.redact to store and search addresses via a one-way hash
class DoNotContact < ApplicationRecord
  include ShinySoftDelete

  # Validations

  validates :email, presence: true, uniqueness: true

  # Before/after actions

  before_validation :strip_email, if: -> { email_changed? }
  before_save :redact_email

  # Class methods

  def self.add( email )
    return unless EmailAddress.valid?( email )

    return :duplicate if include? email
    return :success   if create!( email: email )
  end

  def self.include?( email )
    exists? email: canonicalise_and_redact( email )
  end

  def self.canonicalise_and_redact( email )
    new_email = EmailAddress.new( email )
    return email if new_email.redacted?

    EmailAddress.redact( new_email.canonical )
  end

  private

  def strip_email
    self.email = email.strip
  end

  def redact_email
    self.email = DoNotContact.canonicalise_and_redact( email )
  end
end
