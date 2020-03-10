FactoryBot.define do
  factory :feature_flag do
    name { Faker::Books::CultureSeries.unique.civs.parameterize }
  end
end
