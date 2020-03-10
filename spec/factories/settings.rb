FactoryBot.define do
  factory :setting do
    name   { Faker::Books::CultureSeries.unique.civs.parameterize }
    level  { 'site' }
    locked { false  }
  end
end
