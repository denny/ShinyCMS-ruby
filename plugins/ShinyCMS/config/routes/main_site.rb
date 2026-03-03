# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Main site routes for features in the core plugin

match '404',  to: 'errors#not_found',             via: :all
match '500',  to: 'errors#internal_server_error', via: :all

get '/test/500', to: 'errors#test500' if Rails.env.test?
# get '/test/500', to: 'errors#test500' if Rails.env.test? || Rails.env.development?

devise_for  :users,
            class_name:  'ShinyCMS::User',
            path:        '',
            controllers: {
              confirmations: 'shinycms/users/confirmations',
              passwords:     'shinycms/users/passwords',
              registrations: 'shinycms/users/registrations',
              sessions:      'shinycms/users/sessions',
              unlocks:       'shinycms/users/unlocks'
            },
            path_names:  {
              sign_in:      '/login',
              sign_out:     '/logout',
              registration: '/account',
              sign_up:      'register'
            }
devise_scope :user do
  get 'account/password/report/:password', to: 'users/registrations#password_report', as: :password_report
end

get 'discussions',    to: 'discussions#index', as: :discussions
get 'discussion/:id', to: 'discussions#show',  as: :discussion

get  'discussion/:id/from/:number', to: 'comments#index',  as: :comment_thread
get  'discussion/:id/:number',      to: 'comments#show',   as: :comment
post 'discussion/:id(/:number)',    to: 'comments#create', as: :add_comment

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

post   'vote/:type/:id/:flag', to: 'votes#create',  as: :create_vote
delete 'vote/:type/:id',       to: 'votes#destroy', as: :destroy_vote
