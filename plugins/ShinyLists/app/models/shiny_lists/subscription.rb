# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Model for subscriptions to mailing lists
  class Subscription < ApplicationRecord
    include ShinyDemoDataProvider

    # Associations

    belongs_to :subscriber,      inverse_of: :subscriptions, polymorphic: true
    belongs_to :list,            inverse_of: :subscriptions
    belongs_to :consent_version, inverse_of: :subscriptions

    # Plugin config

    paginates_per 20

    # Scopes

    scope :active,   -> { where(     unsubscribed_at: nil ) }
    scope :inactive, -> { where.not( unsubscribed_at: nil ) }

    scope :recent, -> { order( :subscribed_at ) }

    # Instance methods

    def unsubscribe
      update( unsubscribed_at: Time.zone.now )
    end

    def active?
      unsubscribed_at.blank?
    end
  end
end

::ConsentVersion.has_many :subscriptions, inverse_of: :consent_version, dependent: :restrict_with_error,
                                          class_name: 'ShinyLists::Subscription'
