FactoryBot.define do
  factory :setting do
    name { Faker::DcComics.unique.heroine }
  end
end
