# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for list subscriptions - ShinyLists plugin for ShinyCMS
module ShinyLists
  FactoryBot.define do
    factory :mailing_list_subscription, class: 'ShinyLists::Subscription' do
      association :list,       factory: :mailing_list
      association :subscriber, factory: %i[ email_recipient confirmed ]

      association :consent_version
    end
  end
end
