# frozen_string_literal: true

module ShinyBlogs
  FactoryBot.define do
    factory :shiny_blogs_blog_post, class: 'ShinyBlogs::BlogPost' do
      title  { Faker::Books::CultureSeries.unique.culture_ship.titlecase }
      body   { Faker::Lorem.paragraph }
      posted_at { Time.zone.now.iso8601 }

      association :blog, factory: :shiny_blogs_blog
      association :user
    end
  end
end
