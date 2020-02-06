FactoryBot.define do
  factory :setting do
    name   { "#{Faker::Science.unique.element}_#{Faker::Science.unique.element}".downcase }
    level  { 'site' }
    locked { true   }
  end
end
