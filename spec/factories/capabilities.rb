FactoryBot.define do
  factory :capability do
    name { "#{Faker::Science.unique.element}_#{Faker::Science.unique.element}".downcase }

    association :category, factory: :capability_category
  end
end
