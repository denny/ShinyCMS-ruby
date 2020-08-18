# frozen_string_literal: true

# ============================================================================
# Project:   ShinyBlogs plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyBlogs/config/routes.rb
# Purpose:   Routes for ShinyBlogs plugin
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

ShinyBlogs::Engine.routes.draw do
  scope format: false do
    # Main site
    get 'blogs',                              to: 'blogs#index',
                                              as: :view_blogs
    get 'blog/:blog_slug',                    to: 'blogs#recent',
                                              as: :view_blog
    get 'blog/:blog_slug/:year/:month/:slug', to: 'blogs#show',  as: :view_blog_post,
                                              constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} }
    get 'blog/:blog_slug/:year/:month',       to: 'blogs#month', as: :view_blog_month,
                                              constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} }
    get 'blog/:blog_slug/:year',              to: 'blogs#year',  as: :view_blog_year,
                                              constraints: { year: %r{\d\d\d\d} }

    # Admin area
    scope path: 'admin', module: 'admin' do
      get  :blogs, to: 'blogs#index'
      post :blog,  to: 'blogs#create', as: :create_blog

      resources :blog, controller: :blogs, as: :blog, except: %i[ index show create ] do
        get :posts, to: 'blog/posts#index'
        resources :post, controller: 'blog/posts', except: %i[ index show create ]
      end
      post 'blog/:id/post', to: 'blog/posts#create', as: :create_blog_post
    end
  end
end
