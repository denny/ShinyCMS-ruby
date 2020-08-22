# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Setting model (used together with SettingValue model/factory)
FactoryBot.define do
  factory :setting do
    name   { Faker::Books::CultureSeries.unique.civs.parameterize }
    level  { 'site' }
    locked { false  }
  end
end
