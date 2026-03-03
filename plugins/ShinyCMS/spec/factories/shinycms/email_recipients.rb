# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for EmailRecipient model (no user account but we want to send them email - newsletters, reply notifications, etc)
FactoryBot.define do
  factory :email_recipient, class: 'ShinyCMS::EmailRecipient' do
    name  { Faker::Name.unique.name      }
    email { Faker::Internet.unique.email }

    confirm_sent_at { 2.hours.ago        }
    confirm_token   { SecureRandom.uuid  }

    trait :confirmed do
      # FIXME: "no receiver given"
      # after :create, &:confirm
      # https://github.com/thoughtbot/factory_bot/issues/698 ?
      # rubocop:disable Style/SymbolProc
      after( :create ) { |recipient| recipient.confirm }
      # rubocop:enable Style/SymbolProc
    end
  end
end
