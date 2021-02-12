# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for ShinyAccess plugin

ShinyAccess::Engine.routes.draw do
  scope format: false do
    # Admin area
    scope path: :admin, module: :admin do
      concern :with_paging do
        get '(page/:page)', action: :index, on: :collection, as: ''
      end
      concern :with_search do
        get :search, action: :search, on: :collection
      end

      scope path: :access do
        resources :groups, except: %i[ index show ], concerns: %i[ with_paging with_search ] do
          resources :memberships, only: %i[ create destroy ], concerns: %i[ with_paging with_search ]
        end
      end
    end
  end
end
