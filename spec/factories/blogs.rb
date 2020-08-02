# frozen_string_literal: true

FactoryBot.define do
  factory :blog do
    internal_name { Faker::Books::CultureSeries.unique.culture_ship }
    slug { internal_name.dup.parameterize }

    hidden_from_menu { false }
    hidden { false }

    association :owner, factory: :user
  end
end
