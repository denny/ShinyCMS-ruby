FactoryBot.define do
  factory :capability_category do
    name { "#{Faker::Science.unique.element}_#{Faker::Science.unique.element}".downcase }
  end
end
