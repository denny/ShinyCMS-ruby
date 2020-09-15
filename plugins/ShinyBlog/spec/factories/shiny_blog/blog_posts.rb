# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

FactoryBot.define do
  factory :blog_post, class: 'ShinyBlog::Post' do
    title  { Faker::Books::CultureSeries.unique.culture_ship.titlecase }
    body   { Faker::Lorem.paragraph }
    posted_at { Time.zone.now.iso8601 }

    association :user
  end
end
