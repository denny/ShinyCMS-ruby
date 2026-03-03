# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Setting model (used together with SettingValue model/factory)
FactoryBot.define do
  factory :setting, class: 'ShinyCMS::Setting' do
    name   { Faker::Books::CultureSeries.unique.civs.underscore }
    level  { 'site' }
    locked { false  }
  end

  factory :default_setting, parent: :setting do
    association :setting_value, :default_setting_value
  end

  factory :user_setting, parent: :setting do
    level { 'user' }

    association :setting_value, :user_setting_value
  end
end
