FactoryBot.define do
  factory :capability do
    name { Faker::Science.unique.scientist }
  end
end
