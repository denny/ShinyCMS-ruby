# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Capability model
FactoryBot.define do
  factory :capability, class: 'ShinyCMS::Capability' do
    name { Faker::Books::CultureSeries.unique.civs.underscore }

    association :category, factory: :capability_category
  end
end
