# frozen_string_literal: true

FactoryBot.define do
  factory :discussion do
    hidden { false }

    transient do
      comment_count { 0 }
      comments_posted_at { Time.zone.now.iso8601 }
    end

    after :create do |discussion, evaluator|
      create_list :comment, evaluator.comment_count, posted_at: evaluator.comments_posted_at, discussion: discussion
    end
  end
end
