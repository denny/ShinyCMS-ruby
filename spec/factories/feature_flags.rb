FactoryBot.define do
  factory :feature_flag do
    name { Faker::Lorem.unique.word }
  end
end
