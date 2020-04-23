# frozen_string_literal: true

FactoryBot.define do
  factory :feature_flag do
    name { Faker::Books::CultureSeries.unique.civs.parameterize }
  end
end
