FactoryBot.define do
  factory :blog do
    name   { Faker::Science.unique.scientist }
    title  { name.dup.titlecase }
    slug   { name.dup.downcase.gsub( /[^\w\s]/, '' ).gsub( /\s+/, '-' ) }

    hidden_from_menu { false }
    hidden { false }

    association :user, factory: :user
  end
end
