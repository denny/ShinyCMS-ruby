# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for ShinyNewsletters plugin

ShinyNewsletters::Engine.routes.draw do
  scope format: false do
    # Main site
    get 'newsletters(/page/:page)',        to: 'newsletters#index', as: :user_view_newsletters
    get 'newsletters/:token(/page/:page)', to: 'newsletters#index', as: :token_view_newsletters

    get 'newsletter/:year/:month/:slug',  to: 'newsletters#show', as: :user_view_newsletter,
                                          constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} }

    get 'newsletter/:year/:month/:slug/:token', to: 'newsletters#show', as: :token_view_newsletter,
                                                constraints: { year: %r{\d\d\d\d}, month: %r{\d\d} }

    # Admin area
    scope path: :admin, module: :admin do
      concern :paginatable do
        get '(page/:page)', action: :index, on: :collection, as: ''
      end
      concern :searchable do
        get :search, action: :search, on: :collection
      end

      scope path: :newsletters do
        resources :editions, except: :show, concerns: %i[ paginatable searchable ] do
          get 'send-sample', on: :member
        end

        resources :sends, concerns: %i[ paginatable searchable ] do
          put :start,  on: :member, to: 'sends#start_sending'
          put :pause,  on: :member, to: 'sends#pause_sending'
          put :resume, on: :member, to: 'sends#resume_sending'
          put :cancel, on: :member, to: 'sends#cancel_sending'
        end
        get 'sent(/page/:page)',     to: 'sends#sent', as: :sent
        get 'sends/new/:edition_id', to: 'sends#new',  as: :new_send_for_edition

        resources :templates, except: :show, concerns: %i[ paginatable searchable ]
      end
    end
  end
end
