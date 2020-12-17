# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for AhoyMessage model (part of email stats features)
FactoryBot.define do
  factory :ahoy_message, class: 'Ahoy::Message' do
    token   { Faker::Internet.unique.uuid }
    sent_at { Time.zone.now.iso8601 }

    association :user, factory: :email_recipient
  end
end
