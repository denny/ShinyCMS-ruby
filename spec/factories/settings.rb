FactoryBot.define do
  factory :setting do
    name  { Faker::Lorem.unique.word }
    value { Faker::Lorem.unique.word }
  end
end
