# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyShop::Engine.routes.draw do
  scope format: false do
    # Shop pages
    root to: 'shop#index', as: :shiny_shop_root

    get 'products', to: 'products#index'

    get 'products/:slug', to: 'products#show', as: :product

    resource :checkout, only: :create

    # mount StripeEvent::Engine, at: '/shop/stripe_events'

    # Admin area
    scope path: :admin, module: :admin do
      extend ShinyCMS::Routes::AdminConcerns  # with_paging and with_search

      resources :products, only: %i[ index new edit ]

      post 'products', to: 'products#create', as: :create_product
      put  'products/:id', to: 'products#update', as: :update_product
    end
  end
end
