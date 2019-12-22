FactoryBot.define do
  factory :setting do
    name  { "#{Faker::Science.unique.element}_#{Faker::Science.unique.element}".downcase }
    value { Faker::Lorem.unique.scientist }
  end
end
