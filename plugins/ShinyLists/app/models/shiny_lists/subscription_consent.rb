# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Model to track when a subscriber consents to subscribe to a mailing list
  class SubscriptionConsent < ApplicationRecord
    include ShinyDemoDataProvider

    # Associations

    belongs_to :subscription, inverse_of: :consent
    belongs_to :consent_version, inverse_of: :subscription_consents
  end
end

::ConsentVersion.has_many :subscription_consents, class_name: 'ShinyLists::SubscriptionConsent'
::ConsentVersion.has_many :subscriptions, through: :subscription_consents
