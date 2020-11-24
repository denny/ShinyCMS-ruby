# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Rails routing guide: http://guides.rubyonrails.org/routing.html

# Routes for main app (ShinyCMS core)
Rails.application.routes.draw do
  scope format: false do
    ########################################
    # Main site

    # TODO: figure out what to do here if ShinyPages isn't loaded...
    root to: 'shiny_pages/pages#index' if defined? ShinyPages

    get  :discussions,             to: 'discussions#index', as: :discussions
    get  'discussion/:id',         to: 'discussions#show',  as: :discussion
    post 'discussion/:id',         to: 'discussions#add_comment'
    get  'discussion/:id/:number', to: 'discussions#show_thread', as: :comment
    post 'discussion/:id/:number', to: 'discussions#add_reply'

    get  'email/confirm/:token', to: 'email_recipients#confirm', as: :confirm_email

    get  'email/do-not-contact', to: 'do_not_contact#new', as: :do_not_contact
    post 'email/do-not-contact', to: 'do_not_contact#create'

    get 'site-settings', to: 'site_settings#index'
    put 'site-settings', to: 'site_settings#update'

    get 'tags',       to: 'tags#index', as: :tags
    get 'tags/cloud', to: 'tags#cloud', as: :tag_cloud
    get 'tags/list',  to: 'tags#list',  as: :tag_list
    get 'tag/:tag',   to: 'tags#show',  as: :tag
    get 'tags/:tags', to: 'tags#show',  as: :show_tags

    devise_for  :users,
                path: '',
                controllers: {
                  registrations: 'users/registrations',
                  sessions: 'users/sessions'
                },
                path_names: {
                  sign_in: '/login',
                  sign_out: '/logout',
                  registration: '/account',
                  sign_up: 'register',
                  confirmation: '/account/confirm',
                  password: '/account/password',
                  unlock: '/account/unlock'
                }

    post   'vote/:type/:id/:flag', to: 'votes#create',  as: :create_vote
    delete 'vote/:type/:id',       to: 'votes#destroy', as: :destroy_vote

    ########################################
    # Admin area

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

      # Comment and discussion moderation
      get 'comments(/page/:page)', to: 'comments#index',  as: :comments
      put 'comments',              to: 'comments#update'
      get 'comments/search',       to: 'comments#search', as: :search_comments

      scope path: 'comment' do
        put    ':id/show',    to: 'comments#show',          as: :show_comment
        put    ':id/hide',    to: 'comments#hide',          as: :hide_comment
        put    ':id/lock',    to: 'comments#lock',          as: :lock_comment
        put    ':id/unlock',  to: 'comments#unlock',        as: :unlock_comment
        put    ':id/is-spam', to: 'comments#mark_as_spam',  as: :spam_comment
        delete ':id/delete',  to: 'comments#destroy',       as: :destroy_comment
      end

      scope path: 'discussion' do
        put ':id/show',   to: 'discussions#show',   as: :show_discussion
        put ':id/hide',   to: 'discussions#hide',   as: :hide_discussion
        put ':id/lock',   to: 'discussions#lock',   as: :lock_discussion
        put ':id/unlock', to: 'discussions#unlock', as: :unlock_discussion
      end

      # Email Recipients
      resources :email_recipients, path: 'email-recipients', concerns: %i[ paginatable searchable ],
                                   except: %i[ show new create ] do
        put :'do-not-contact', on: :member, to: 'email_recipients#do_not_contact'
      end

      # Feature Flags
      get 'feature-flags', to: 'feature_flags#index'
      put 'feature-flags', to: 'feature_flags#update'

      # Site settings
      get 'site-settings', to: 'site_settings#index', as: :admin_site_settings
      put 'site-settings', to: 'site_settings#update'

      # Stats
      get 'email-stats(/page/:page)',            to: 'email_stats#index',  as: :email_stats
      get 'email-stats/user/:user_id',           to: 'email_stats#index',  as: :user_email_stats
      get 'email-stats/recipient/:recipient_id', to: 'email_stats#index',  as: :recipient_email_stats
      get 'email-stats/search',                  to: 'email_stats#search', as: :search_email_stats

      get 'web-stats(/page/:page)',              to: 'web_stats#index',  as: :web_stats
      get 'web-stats/user/:user_id',             to: 'web_stats#index',  as: :user_web_stats
      get 'web-stats/search',                    to: 'web_stats#search', as: :search_web_stats

      # Users
      resources :users, except: :show, concerns: %i[ paginatable searchable ]
      get 'users/usernames', to: 'users#username_search', as: :search_usernames
    end

    ########################################
    # Rails engines

    # AhoyEmail provides email tracking features
    mount AhoyEmail::Engine, at: '/ahoy'

    # Blazer provides charts and dashboards in the admin area
    mount Blazer::Engine, at: '/admin/stats'

    # CKEditor provides the WYSIWYG editor used in the admin area
    mount Ckeditor::Engine, at: '/admin/ckeditor'

    # RailsEmailPreview provides previews of site emails in the admin area
    mount RailsEmailPreview::Engine, at: '/admin/email-previews'

    def sidekiq_web_enabled?
      ENV['DISABLE_SIDEKIQ_WEB']&.downcase != 'true'
    end

    # Sidekiq Web provides a web dashboard for your sidekiq jobs and queues
    if sidekiq_web_enabled?
      require 'sidekiq/web'
      require 'sidekiq-status/web'

      Sidekiq::Web.set :sessions, false
      authenticate :user, ->( user ) { user.can? :manage_sidekiq_jobs } do
        mount Sidekiq::Web, at: '/admin/sidekiq'
      end
    end

    # LetterOpener catches all emails sent in development, with a webmail UI to view them
    mount LetterOpenerWeb::Engine, at: '/dev/outbox' if Rails.env.development?

    ########################################
    # ShinyCMS plugins

    ShinyPlugin.loaded.each do |plugin|
      mount plugin.engine, at: '/' if plugin.engine.present?
    end

    ########################################################################################################
    # This route explicitly intercepts any request starting with /admin that wasn't otherwise handled
    match '/admin/*path', to: 'admin#not_found', as: :admin_not_found, via: %i[ get post put patch delete ]

    ########################################################################################################
    # This catch-all route matches anything and everything not already matched by a route defined before it.
    # It has to be the last route set up, because it hijacks anything that gets this far.
    # This route gives us pages and sections at the top level, e.g. /foo instead of /pages/foo
    # TODO: figure out how to load a route last for the whole app, from inside a plugin's routes.rb
    if defined? ShinyPages
      get '*path', to: 'shiny_pages/pages#show', constraints: lambda { |req|
        !req.path.starts_with?( '/rails/active_' )
      }
    end
  end
end
