# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyLists::Engine.routes.draw do
  scope format: false do
    # Main site
    get  'lists/subscriptions(/page/:page)',        to: 'subscriptions#index', as: :user_list_subscriptions
    get  'lists/subscriptions/:token(/page/:page)', to: 'subscriptions#index', as: :token_list_subscriptions

    post 'list/:slug/subscribe', to: 'subscriptions#subscribe', as: :list_subscribe

    put  'list/:slug/unsubscribe',        to: 'subscriptions#unsubscribe', as: :user_list_unsubscribe
    put  'list/:slug/unsubscribe/:token', to: 'subscriptions#unsubscribe', as: :token_list_unsubscribe

    # Admin area
    scope path: 'admin', module: 'admin' do
      extend ShinyCMS::Routes::AdminConcerns  # with_paging and with_search

      resources :lists, except: %i[ index show ], concerns: %i[ with_paging with_search ] do
        resources :subscriptions, only: %i[ create destroy  ], concerns: %i[ with_paging with_search ]
      end
    end
  end
end
