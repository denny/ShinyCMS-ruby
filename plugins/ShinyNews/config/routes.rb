# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyNews::Engine.routes.draw do
  scope format: false do
    # Main site
    get 'news', to: 'news#index', as: :view_news

    get 'news/:year',               constraints: { year: %r{\d\d\d\d} },
                                    to: 'news#year', as: :view_news_year

    get 'news/:year/:month',        constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} },
                                    to: 'news#month', as: :view_news_month

    get 'news/:year/:month/:slug',  constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} },
                                    to: 'news#show', as: :view_news_post

    # Admin area
    scope path: 'admin', module: 'admin' do
      get 'news/search', to: 'news_posts#search', as: :news_posts_search

      resources :news_posts, path: 'news', except: :show
    end
  end
end
