# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Discussion model
FactoryBot.define do
  factory :discussion, class: 'ShinyCMS::Discussion' do
    transient do
      comment_count { 0 }
      comments_posted_at { Time.zone.now.iso8601 }

      association :resource, factory: :news_post
    end

    after :create do |discussion, evaluator|
      create_list :comment, evaluator.comment_count, posted_at: evaluator.comments_posted_at, discussion: discussion
    end
  end
end
