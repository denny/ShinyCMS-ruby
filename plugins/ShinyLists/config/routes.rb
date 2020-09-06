# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for ShinyLists plugin

ShinyLists::Engine.routes.draw do
  scope format: false do
    # Main site
    get  'lists/subscriptions/:token',    to: 'subscriptions#index',       as: :token_list_subscriptions
    get  'lists/subscriptions',           to: 'subscriptions#index',       as: :user_list_subscriptions

    post 'list/:slug/subscribe',          to: 'subscriptions#subscribe',   as: :list_subscribe

    put  'list/:slug/unsubscribe/:token', to: 'subscriptions#unsubscribe', as: :token_list_unsubscribe
    put  'list/:slug/unsubscribe',        to: 'subscriptions#unsubscribe', as: :user_list_unsubscribe

    # Admin area
    scope path: 'admin', module: 'admin' do
      resources :lists, except: :show do
        get    :subscriptions,      to: 'subscriptions#index'
        post   :subscriptions,      to: 'subscriptions#subscribe',   as: :admin_subscribe
        delete 'subscriptions/:id', to: 'subscriptions#unsubscribe', as: :admin_unsubscribe
      end
    end
  end
end
