# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for blog posts - ShinyBlogs plugin for ShinyCMS
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
