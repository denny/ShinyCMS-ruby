FactoryBot.define do
  factory :blog do
    name   { Faker::Science.unique.scientist }
    title  { name.dup.titlecase }
    slug   { name.dup.parameterize }

    hidden_from_menu { false }
    hidden { false }

    association :user, factory: :user
  end
end
