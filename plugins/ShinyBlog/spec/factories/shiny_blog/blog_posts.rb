# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for blog posts - ShinyBlog plugin for ShinyCMS
module ShinyBlog
  FactoryBot.define do
    factory :blog_post, class: 'ShinyBlog::Post' do
      title  { Faker::Books::CultureSeries.unique.culture_ship }
      body   { Faker::Lorem.paragraph }
      posted_at { Time.zone.now.iso8601 }

      association :user, factory: :blog_admin
    end

    factory :long_blog_post, parent: :blog_post do
      body { Faker::Lorem.paragraphs( number: 5 ).join( '<br><br>' ) }
    end
  end
end
