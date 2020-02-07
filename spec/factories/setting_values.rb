FactoryBot.define do
  factory :setting_value do
    value { Faker::Science.unique.scientist }
  end
end
