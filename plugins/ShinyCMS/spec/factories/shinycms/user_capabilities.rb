# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for UserCapability model
FactoryBot.define do
  factory :user_capability, class: 'ShinyCMS::UserCapability' do
    association :user
    association :capability
  end
end
