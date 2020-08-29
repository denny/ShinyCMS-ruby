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
    get 'list/subscriptions/:token', to: 'subscriptions#index', as: :token_list_subscriptions
    get 'list/subscriptions',        to: 'subscriptions#index', as: :user_list_subscriptions

    post 'list/:slug/subscribe', to: 'subscriptions#create', as: :create_list_subscription

    put 'list/:slug/unsubscribe/:token', to: 'subscriptions#unsubscribe', as: :token_list_unsubscribe
    put 'list/:slug/unsubscribe',        to: 'subscriptions#unsubscribe', as: :user_list_unsubscribe

    # Admin area
    scope path: 'admin', module: 'admin' do
      resources :lists, except: :show do
        resources :subscriptions, except: :show
      end
    end
  end
end
