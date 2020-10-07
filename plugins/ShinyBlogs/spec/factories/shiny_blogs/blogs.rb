# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for blogs - ShinyBlogs plugin for ShinyCMS
module ShinyBlogs
  FactoryBot.define do
    factory :shiny_blogs_blog, class: 'ShinyBlogs::Blog' do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }

      association :user, factory: :multi_blog_admin
    end
  end
end
