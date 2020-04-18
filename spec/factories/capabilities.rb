# frozen_string_literal: true

FactoryBot.define do
  factory :capability do
    name { Faker::Books::CultureSeries.unique.civs.parameterize }

    association :category, factory: :capability_category
  end
end
