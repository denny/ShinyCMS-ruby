FactoryBot.define do
  factory :setting do
    name  { "#{Faker::Science.unique.element}_#{Faker::Science.unique.element}".downcase }
    value { Faker::Science.unique.scientist }
  end
end
