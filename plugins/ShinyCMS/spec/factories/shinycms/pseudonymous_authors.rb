# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for unauthenticated comment authors
FactoryBot.define do
  factory :pseudonymous_author, class: 'ShinyCMS::PseudonymousAuthor' do
    name { Faker::Name.unique.name }
    ip_address { Faker::Internet.unique.ip_v4_address }
    token { SecureRandom.uuid }

    trait :with_email do
      association :email_recipient, :confirmed, name: name
    end

    trait :with_url do
      url { Faker::Internet.unique.url }
    end
  end
end
