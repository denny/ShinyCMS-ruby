# frozen_string_literal: true

# ============================================================================
# Project:   ShinyPages plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyPages/config/routes.rb
# Purpose:   Routes for ShinyPages plugin
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

ShinyPages::Engine.routes.draw do
  scope format: false do
    # Main site
    root to: 'pages#index'

    # Admin area
    scope path: :admin, module: :admin do
      resources :pages, except: [ :show ]

      scope path: :pages do
        resources :sections,  except: [ :show ]
        resources :templates, except: [ :show ]
      end
    end

    ###########################################################################
    # This catch-all route matches anything and everything not already matched by a route defined before it.
    # It has to be the last route set up, because it hijacks anything that reaches it.
    # This makes it possible to have pages and sections at the top level, e.g. /foo instead of /pages/foo
    # TODO: work out how to load this last from inside the ShinyPages plugin routes.rb
    # get '*path', to: 'pages#show'
  end
end
