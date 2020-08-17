# frozen_string_literal: true

FactoryBot.define do
  factory :blog_post, class: 'ShinyBlog::Post' do
    title  { Faker::Books::CultureSeries.unique.culture_ship.titlecase }
    body   { Faker::Lorem.paragraph }
    posted_at { Time.zone.now.iso8601 }

    association :user
  end
end
