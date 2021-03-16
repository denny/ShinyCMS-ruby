# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for ShinyCMS admin area, for core plugin features

get :admin, to: 'admin#index'

scope path: 'admin', module: 'admin' do
  # with_paging and with_search
  import_routes partial: :admin_route_concerns

  # Consent versions
  resources :consent_versions, path: 'consent-versions', concerns: %i[ with_paging with_search ], except: :index

  # Admin area routes for comments and discussions
  import_routes partial: :admin_area_for_discussions

  # Email Recipients
  resources :email_recipients, path: 'email-recipients', concerns: %i[ with_paging with_search ], only: :destroy do
    put :'do-not-contact', on: :member, to: 'email_recipients#do_not_contact'
  end

  # Feature Flags
  get 'feature-flags', to: 'feature_flags#index'
  put 'feature-flags', to: 'feature_flags#update'

  # Site settings
  get 'site-settings', to: 'site_settings#index', as: :admin_site_settings
  put 'site-settings', to: 'site_settings#update'

  # Admin area routes for web and email stats
  import_routes partial: :admin_area_for_stats

  # Users
  resources :users, concerns: %i[ with_paging with_search ], except: %i[ index show ]
  get 'users/usernames', to: 'users#username_search', as: :search_usernames
end
