FactoryBot.define do
  factory :capability_category do
    name { Faker::Lorem.unique.word }
  end
end
