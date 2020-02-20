FactoryBot.define do
  factory :comment do
    # number { Comment.where( discussion_id: discussion_id ).max( :id ) + 1 }
    sequence( :number )
    title  { Faker::Science.unique.scientist }
    body   { Faker::Lorem.paragraph }
    hidden { false }
  end

  factory :top_level_comment, parent: :comment do
    parent_id { nil }
  end

  factory :nested_comment, parent: :comment do
  end
end
