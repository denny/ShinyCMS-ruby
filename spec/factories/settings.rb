FactoryBot.define do
  factory :setting do
    name  { Faker::Science.unique.scientist }
    value { Faker::Science.element }
  end
end
