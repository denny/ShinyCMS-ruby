# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyAccess::Engine.routes.draw do
  scope format: false do
    # Admin area
    scope path: :admin, module: :admin do
      extend ShinyCMS::Routes::AdminConcerns  # with_paging and with_search

      scope path: :access do
        resources :groups, except: %i[ index show ], concerns: %i[ with_paging with_search ] do
          resources :memberships, only: %i[ create destroy ], concerns: %i[ with_paging with_search ]
        end
      end
    end
  end
end
