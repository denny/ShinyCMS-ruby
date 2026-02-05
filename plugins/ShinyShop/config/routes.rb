# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyShop::Engine.routes.draw do
  scope format: false do
    # Shop pages
    root to: 'shop#index', as: :shiny_shop_root

    get 'shop', to: 'products#index'

    # get 'shop/:slug', to: 'products#index', as: :products_index

    # get 'shop/:slug', to: 'products#show', as: :show_product

    get 'shop/*path', to: 'products#product_or_section', as: :product_or_section

    resource :checkout, only: :create

    # mount StripeEvent::Engine, at: '/shop/stripe_events'

    # Admin area
    scope path: :admin, module: :admin do
      extend ShinyCMS::Routes::AdminConcerns  # with_paging and with_search

      concern :sortable do
        put :sort, on: :collection
      end

      resources :products, except: %i[ show destroy ], concerns: %i[ with_paging with_search sortable ]

      put 'products/:id/archive', to: 'products#archive', as: :archive_product
      put 'products/:id/revive',  to: 'products#revive',  as: :revive_product

      scope path: :products do
        resources :sections, except: :show

        resources :templates, except: %i[ index show ], concerns: %i[ with_paging with_search ] do
          resources :elements, only: %i[ create destroy ], module: :templates
        end
      end
    end
  end
end
