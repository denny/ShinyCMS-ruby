# frozen_string_literal: true

FactoryBot.define do
  factory :setting_value do
    value { Faker::Books::CultureSeries.unique.culture_ship }
  end
end
