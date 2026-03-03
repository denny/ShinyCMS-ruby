# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Plays the role of Author for pseudonymous Comments
  class PseudonymousAuthor < ApplicationRecord
    include ShinyCMS::HasToken
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    has_many :comments, as: :author, dependent: :nullify, class_name: 'ShinyCMS::Comment'

    belongs_to :email_recipient, optional: true, class_name: 'ShinyCMS::EmailRecipient'

    def email
      return if email_recipient.blank?

      email_recipient.email
    end

    def self.my_demo_data_position
      2  # after email recipients
    end
  end
end
