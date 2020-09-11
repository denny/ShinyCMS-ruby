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
    get 'newsletters',        to: 'newsletters#index', as: :user_view_newsletters
    get 'newsletters/:token', to: 'newsletters#index', as: :token_view_newsletters

    get 'newsletter/:year/:month/:slug',  to: 'newsletters#show', as: :user_view_newsletter,
                                          constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} }

    get 'newsletter/:year/:month/:slug/:token', to: 'newsletters#show', as: :token_view_newsletter,
                                                constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} }

    # Admin area
    scope path: :admin, module: :admin do
      scope path: :newsletters do
        resources :templates, except: [ :show ]
        resources :editions,  except: [ :show ]

        resources :sends do
          put :pause,  to: 'sends#pause'
          put :resume, to: 'sends#resume'
          put :cancel, to: 'sends#cancel'
        end
        get :sent, to: 'sends#sent'
      end
    end
  end
end
