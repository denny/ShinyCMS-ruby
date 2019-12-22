FactoryBot.define do
  factory :blog do
    name   { Faker::Lorem.unique.sentence }
    title  { name.dup.titlecase }
    slug   { Faker::Lorem.unique.word.downcase }

    hidden_from_menu { false }
    hidden { false }

    association :user, factory: :user
  end
end
