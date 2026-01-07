# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyBlog::Engine.routes.draw do
  scope format: false do
    yyyy_mm = { year: %r{\d\d\d\d}, month: %r{\d\d} }
    yyyy    = { year: %r{\d\d\d\d} }

    # Main site
    get 'blog(/page/:page)(/items/:items)', to: 'blog#index', as: :view_blog

    get 'blog/:year',              to: 'blog#year',  as: :view_blog_year,  constraints: yyyy
    get 'blog/:year/:month',       to: 'blog#month', as: :view_blog_month, constraints: yyyy_mm
    get 'blog/:year/:month/:slug', to: 'blog#show',  as: :view_blog_post,  constraints: yyyy_mm

    # Admin area
    scope path: 'admin', module: 'admin' do
      extend ShinyCMS::Routes::AdminConcerns  # with_paging and with_search

      resources :blog_posts, path: 'blog', except: %i[ index show ], concerns: %i[ with_paging with_search ]
    end
  end
end
