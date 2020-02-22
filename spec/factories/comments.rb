FactoryBot.define do
  factory :comment do
    sequence( :number )
    title   { Faker::Science.unique.scientist }
    body    { Faker::Lorem.paragraph }
    hidden  { false }
  end

  factory :top_level_comment, parent: :comment do
    parent_id { nil }
  end

  factory :nested_comment, parent: :comment do
  end
end
