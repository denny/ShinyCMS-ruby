FactoryBot.define do
  factory :blog do
    name  { Faker::Books::CultureSeries.unique.culture_ship }
    title { name.dup.titlecase    }
    slug  { name.dup.parameterize }

    hidden_from_menu { false }
    hidden { false }

    association :owner, factory: :user
  end
end
