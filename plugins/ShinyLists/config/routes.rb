# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for ShinyLists plugin

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
      concern :paginatable do
        get '(page/:page)', action: :index, on: :collection, as: ''
      end
      concern :searchable do
        get :search, action: :search, on: :collection
      end

      resources :lists, except: :show, concerns: %i[ paginatable searchable ] do
        resources :subscriptions, only: :index, concerns: %i[ paginatable searchable ]
      end
      post   'list/:list_id/subscriptions',     to: 'subscriptions#subscribe',   as: :admin_list_subscribe
      delete 'list/:list_id/subscriptions/:id', to: 'subscriptions#unsubscribe', as: :admin_list_unsubscribe
    end
  end
end
