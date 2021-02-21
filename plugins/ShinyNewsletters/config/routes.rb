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
      concern :with_paging do
        get '(page/:page)', action: :index, on: :collection, as: ''
      end
      concern :with_search do
        get :search, action: :search, on: :collection
      end

      scope path: :newsletters do
        resources :editions, except: %i[ index show ], concerns: %i[ with_paging with_search ] do
          get 'send-sample', on: :member
        end

        resources :templates, except: %i[ index show ], concerns: %i[ with_paging with_search ]

        resources :sends, except: :index, concerns: %i[ with_paging with_search ] do
          put :start,  on: :member, to: 'sends#start_sending'
          put :pause,  on: :member, to: 'sends#pause_sending'
          put :resume, on: :member, to: 'sends#resume_sending'
          put :cancel, on: :member, to: 'sends#cancel_sending'
        end
        get 'sent(/page/:page)',     to: 'sends#sent', as: :sent
        get 'sends/new/:edition_id', to: 'sends#new',  as: :new_send_for_edition
      end
    end
  end
end
