# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for CapabilityCategory model
FactoryBot.define do
  factory :capability_category do
    name { Faker::Books::CultureSeries.unique.civs.underscore }
  end
end
