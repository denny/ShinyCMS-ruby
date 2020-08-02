# frozen_string_literal: true

FactoryBot.define do
  factory :blog_post, class: 'BlogPost' do
    title  { Faker::Books::CultureSeries.unique.culture_ship.titlecase }
    slug   { title.dup.parameterize }
    body   { Faker::Lorem.paragraph }
    posted_at { Time.zone.now.iso8601 }

    association :blog,   factory: :blog
    association :author, factory: :user
  end
end
