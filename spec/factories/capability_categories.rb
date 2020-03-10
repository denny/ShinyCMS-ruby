FactoryBot.define do
  factory :capability_category do
    name { Faker::Books::CultureSeries.unique.civs.parameterize }
  end
end
