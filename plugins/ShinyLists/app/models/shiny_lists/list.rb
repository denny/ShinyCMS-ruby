# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Model for mailing lists
  class List < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyName
    include ShinySlug

    # Assocations

    has_many :subscriptions, dependent: :destroy
    has_many :users, through: :subscriptions, source: :subscriber, source_type: 'User'
    has_many :email_recipients, through: :subscriptions, source: :subscriber, source_type: 'EmailRecipient'

    # Plugin config

    paginates_per 20

    # Instance methods

    def subscribe( subscriber )
      return if subscribed? subscriber.email

      subscriptions.find_or_create_by!( subscriber: subscriber )
    end

    def subscribed?( email_address )
      users.exists?( email: email_address ) ||
        email_recipients.exists?( email: email_address )
    end

    def policy_class
      self.class.policy_class
    end

    # Class methods

    def self.policy_class
      ShinyLists::ListPolicy
    end
  end
end

::EmailRecipient.has_many :lists, through: :subscriptions, class_name: 'ShinyLists::List'
::User.has_many :lists, through: :subscriptions, class_name: 'ShinyLists::List'
