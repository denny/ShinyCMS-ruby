# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for list subscriptions - ShinyLists plugin for ShinyCMS
FactoryBot.define do
  factory :mailing_list_subscription, class: 'ShinyLists::Subscription' do
  end
end
