FactoryBot.define do
  factory :feature_flag do
    name { "#{Faker::Science.unique.element}_#{Faker::Science.unique.element}".downcase }
  end
end
