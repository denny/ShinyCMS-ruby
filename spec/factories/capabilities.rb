FactoryBot.define do
  factory :capability do
    name { Faker::Science.unique.scientist }

    association :category, factory: :capability_category
  end
end
