# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyPages::Engine.routes.draw do
  scope format: false do
    # Main site
    root to: 'pages#index', as: :shiny_pages_root

    # Admin area
    scope path: :admin, module: :admin do
      extend ShinyCMS::Routes::AdminConcerns  # with_paging and with_search

      concern :sortable do
        put :sort, on: :collection
      end

      resources :pages, except: %i[ index show ], concerns: %i[ with_paging with_search sortable ] do
        resources :elements, only: %i[ create destroy ], module: :pages
      end

      scope path: :pages do
        resources :sections, except: :show

        resources :templates, except: %i[ index show ], concerns: %i[ with_paging with_search ] do
          resources :elements, only: %i[ create destroy ], module: :templates
        end
      end
    end
  end
end
