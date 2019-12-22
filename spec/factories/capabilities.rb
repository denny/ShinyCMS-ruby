FactoryBot.define do
  factory :capability do
    name { Faker::Lorem.unique.word }

    association :category, factory: :capability_category
  end
end
