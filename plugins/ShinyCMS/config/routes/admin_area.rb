# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Admin area routes for features in the core plugin

get :admin, to: 'admin/root#index'

scope path: 'admin', module: 'admin' do
  extend ShinyCMS::Routes::AdminConcerns  # with_paging and with_search

  get 'comments(/page/:page)', to: 'comments#index',  as: :comments
  put 'comments',              to: 'comments#update'
  get 'comments/search',       to: 'comments#search', as: :search_comments

  scope path: 'comment' do
    put    ':id/show',      to: 'comments#show',          as: :show_comment
    put    ':id/hide',      to: 'comments#hide',          as: :hide_comment
    put    ':id/lock',      to: 'comments#lock',          as: :lock_comment
    put    ':id/unlock',    to: 'comments#unlock',        as: :unlock_comment
    put    ':id/flag-spam', to: 'comments#mark_as_spam',  as: :flag_spam_comment
    delete ':id/spam',      to: 'comments#destroy',       as: :destroy_spam_comment
    delete ':id/delete',    to: 'comments#destroy',       as: :destroy_comment
  end

  resources :consent_versions, path: 'consent-versions', except: :index, concerns: %i[ with_paging with_search ]

  scope path: 'discussion' do
    put ':id/show',   to: 'discussions#show',   as: :show_discussion
    put ':id/hide',   to: 'discussions#hide',   as: :hide_discussion
    put ':id/lock',   to: 'discussions#lock',   as: :lock_discussion
    put ':id/unlock', to: 'discussions#unlock', as: :unlock_discussion
  end

  resources :email_recipients, path: 'email-recipients', only: :destroy, concerns: %i[ with_paging with_search ] do
    put :'do-not-contact', on: :member, to: 'email_recipients#do_not_contact'
  end

  get 'email-stats(/page/:page)',            to: 'email_stats#index',  as: :email_stats
  get 'email-stats/user/:user_id',           to: 'email_stats#index',  as: :user_email_stats
  get 'email-stats/recipient/:recipient_id', to: 'email_stats#index',  as: :recipient_email_stats
  get 'email-stats/search',                  to: 'email_stats#search', as: :search_email_stats

  get 'feature-flags', to: 'feature_flags#index'
  put 'feature-flags', to: 'feature_flags#update'

  get 'site-settings', to: 'site_settings#index', as: :admin_site_settings
  put 'site-settings', to: 'site_settings#update'

  resources :users, concerns: %i[ with_paging with_search ], except: %i[ index show ]
  get 'users/usernames', to: 'users#username_search', as: :search_usernames

  get 'web-stats(/page/:page)',  to: 'web_stats#index',  as: :web_stats
  get 'web-stats/user/:user_id', to: 'web_stats#index',  as: :user_web_stats
  get 'web-stats/search',        to: 'web_stats#search', as: :search_web_stats
end
