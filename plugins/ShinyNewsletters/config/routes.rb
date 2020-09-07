# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for ShinyNewsletters plugin

ShinyNewsletters::Engine.routes.draw do
  scope format: false do
    # Main site
    resources :newsletters, only: %i[ index show ]

    # Admin area
    scope path: :admin, module: :admin do
      scope path: :newsletters do
        resources :templates, except: [ :show ]
        resources :editions,  except: [ :show ]
        resources :sends
      end
    end
  end
end
