# frozen_string_literal: true

FactoryBot.define do
  factory :blog do
    internal_name { Faker::Books::CultureSeries.unique.culture_ship }

    association :owner, factory: :user
  end
end
