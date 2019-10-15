FactoryBot.define do
  factory :setting do
    name { Faker::Science.unique.scientist }
  end
end
