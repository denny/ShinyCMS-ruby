# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Store details of people you send email to, who don't have a user account (e.g. newsletter subscribers)
class EmailRecipient < ApplicationRecord
  include ShinyDemoDataProvider
  include ShinyEmail

  # Associations

  has_many :messages, class_name: 'Ahoy::Message', as: :user, dependent: :nullify

  # Validations

  validates :token, presence: true, uniqueness: true

  # Before/after actions

  before_validation :generate_token, if: -> { token.blank? }

  private

  def generate_token
    self.token = SecureRandom.uuid
  end
end
