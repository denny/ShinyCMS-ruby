FactoryBot.define do
  factory :capability_category do
    name { Faker::Science.unique.element }
  end
end
