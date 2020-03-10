FactoryBot.define do
  factory :subscriber do
    name  { Faker::Books::CultureSeries.unique.culture_ship }
    email { Faker::Internet.unique.email }
    token { Faker::Internet.unique.uuid  }
  end
end
