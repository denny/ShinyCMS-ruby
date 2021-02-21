# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for the ShinyBlogs plugin for ShinyCMS

ShinyBlogs::Engine.routes.draw do
  scope format: false do
    # Main site
    get 'blogs',                                to: 'blogs#index',  as: :view_blogs

    get 'blogs/:blog_slug',                     to: 'blogs#recent', as: :view_blog

    get 'blogs/:blog_slug/:year',               to: 'blogs#year',   as: :view_blog_year,
                                                constraints: { year: %r{\d\d\d\d} }

    get 'blogs/:blog_slug/:year/:month',        to: 'blogs#month',  as: :view_blog_month,
                                                constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} }

    get 'blogs/:blog_slug/:year/:month/:slug',  to: 'blogs#show',   as: :view_blog_post,
                                                constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} }

    # Admin area
    scope path: 'admin', module: 'admin' do
      resources :blogs, except: [ :show ] do
        resources :posts, except: [ :show ]
      end
    end
  end
end
