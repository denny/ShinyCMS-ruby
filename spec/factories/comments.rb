# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    sequence( :number )
    title   { Faker::Books::CultureSeries.unique.culture_ship.titlecase }
    body    { Faker::Lorem.paragraph }
    hidden  { false }
    author_type { 'anonymous' }
  end

  factory :top_level_comment, parent: :comment do
    parent_id { nil }
  end

  factory :nested_comment, parent: :comment do
  end
end
