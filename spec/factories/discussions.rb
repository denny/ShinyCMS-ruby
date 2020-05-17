# frozen_string_literal: true

FactoryBot.define do
  factory :discussion do
    hidden { false }

    trait :with_0to4_comments do
      after :create do |discussion|
        create_list :comment, rand(5), discussion: discussion
      end
    end

    trait :with_four_comments do
      after :create do |discussion|
        create_list :comment, 4, discussion: discussion
      end
    end

    trait :with_five_comments do
      after :create do |discussion|
        create_list :comment, 5, discussion: discussion
      end
    end

    trait :with_6old_comments do
      after :create do |discussion|
        create_list :comment, 6, discussion: discussion, posted_at: 8.days.ago
      end
    end

    factory :discussion_with_four_comments, traits: [ :with_four_comments ]
    factory :discussion_with_five_comments, traits: [ :with_five_comments ]
    factory :discussion_with_6old_comments, traits: [ :with_6old_comments ]
  end
end
