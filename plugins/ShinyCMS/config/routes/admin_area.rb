# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for ShinyCMS admin area, for core plugin features

get :admin, to: 'admin#index'

concern :paginatable do
  get '(page/:page)', action: :index, on: :collection, as: ''
end
concern :searchable do
  get :search, on: :collection
end

scope path: 'admin', module: 'admin' do
  # Consent versions
  resources :consent_versions, path: 'consent-versions', concerns: %i[ paginatable searchable ]

  # Admin area routes for comments and discussions
  import_routes file: :admin_area_for_discussions

  # Email Recipients
  resources :email_recipients, path: 'email-recipients', concerns: %i[ paginatable searchable ],
                                only: %i[ index destroy ] do
    put :'do-not-contact', on: :member, to: 'email_recipients#do_not_contact'
  end

  # Feature Flags
  get 'feature-flags', to: 'feature_flags#index'
  put 'feature-flags', to: 'feature_flags#update'

  # Site settings
  get 'site-settings', to: 'site_settings#index', as: :admin_site_settings
  put 'site-settings', to: 'site_settings#update'

  # Admin area routes for web and email stats
  import_routes file: :admin_area_for_stats

  # Users
  resources :users, except: :show, concerns: %i[ paginatable searchable ]
  get 'users/usernames', to: 'users#username_search', as: :search_usernames
end
