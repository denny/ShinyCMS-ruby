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

        get 'editions/:id/send-sample', to: 'editions#send_sample', as: :send_sample

        resources :sends
        get :sent, to: 'sends#sent'

        scope path: :sends do
          put ':id/start',  to: 'sends#start_sending',  as: :start_sending
          put ':id/pause',  to: 'sends#pause_sending',  as: :pause_sending
          put ':id/resume', to: 'sends#resume_sending', as: :resume_sending
          put ':id/cancel', to: 'sends#cancel_sending', as: :cancel_sending

          get 'new/:edition_id', to: 'sends#new', as: :new_send_for_edition
        end
      end
    end
  end
end
