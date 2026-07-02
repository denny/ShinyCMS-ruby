# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyNews::Engine.routes.draw do
  scope format: false do
    yyyy_mm = { year: %r{\d\d\d\d}, month: %r{\d\d} }
    yyyy    = { year: %r{\d\d\d\d} }

    # Main site
    get 'news(/page/:page)(/items/:items)', to: 'news#index', as: :view_news

    get 'news/:year',              to: 'news#year',  as: :view_news_year,  constraints: yyyy
    get 'news/:year/:month',       to: 'news#month', as: :view_news_month, constraints: yyyy_mm
    get 'news/:year/:month/:slug', to: 'news#show',  as: :view_news_post,  constraints: yyyy_mm

    # Admin area
    scope path: 'admin', module: 'admin' do
      extend ShinyCMS::Routes::AdminConcerns  # with_paging and with_search

      resources :news_posts, path: 'news', except: %i[ index show ], concerns: %i[ with_paging with_search ]
    end
  end
end
