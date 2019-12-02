FactoryBot.define do
  factory :feature_flag do
    name  { Faker::Science.unique.scientist }
    state { 'Off' }
  end
end
