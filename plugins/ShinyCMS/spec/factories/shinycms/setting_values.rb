# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for SettingValue model (used together with Setting model/factory)
FactoryBot.define do
  factory :setting_value, class: 'ShinyCMS::SettingValue', aliases: [ :default_setting_value ] do
    value { Faker::Books::CultureSeries.unique.culture_ship }
  end

  factory :user_setting_value, parent: :setting_value do
    association :user
  end
end
