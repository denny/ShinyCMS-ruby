# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyPages::Engine.routes.draw do
  scope format: false do
    # Main site
    root to: 'pages#index'

    # Admin area
    scope path: :admin, module: :admin do
      concern :paginatable do
        get '(page/:page)', action: :index, on: :collection, as: ''
      end
      concern :searchable do
        get :search, on: :collection
      end
      concern :sortable do
        put :sort, on: :collection
      end

      resources :pages, except: :show, concerns: %i[ paginatable searchable sortable ]

      scope path: :pages do
        resources :sections,  except: :show
        resources :templates, except: :show, concerns: %i[ paginatable searchable ]
      end
    end

    ########################################################################################################
    # This catch-all route matches anything and everything not already matched by a route defined before it.
    # It has to be the last route set up, because it hijacks anything that gets this far.
    # This route gives us pages and sections at the top level, e.g. /foo instead of /pages/foo
    # TODO: work out how to load this (last!) from here, instead of main_app's config/routes.rb
    # get '*path', to: 'pages#show', constraints: lambda { |req|
    #   !req.path.starts_with?( '/rails/active_' )
    # }
  end
end
