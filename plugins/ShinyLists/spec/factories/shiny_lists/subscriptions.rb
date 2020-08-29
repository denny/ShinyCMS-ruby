# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for list subscriptions - ShinyNewsletters plugin for ShinyCMS
FactoryBot.define do
  factory :newsletter_subscription, class: 'ShinyNewsletters::Subscription' do
  end
end
