# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for ShinyCMS main site, for core plugin features

# Smarter error pages
match '404',  to: 'errors#not_found',             via: :all
match '500',  to: 'errors#internal_server_error', via: :all

get '/test/500', to: 'errors#test500' if Rails.env.test?

# User Accounts / Authentication
devise_for  :users,
            class_name:  'ShinyCMS::User',
            path:        '',
            controllers: {
              registrations: 'shinycms/users/registrations',
              sessions:      'shinycms/users/sessions'
            },
            path_names:  {
              sign_in:      '/login',
              sign_out:     '/logout',
              registration: '/account',
              sign_up:      'register',
              confirmation: '/account/confirm',
              password:     '/account/password',
              unlock:       '/account/unlock'
            }

devise_scope :user do
  get 'account/password/report/:password', to: 'users/registrations#password_report', as: :password_report
end

get  'discussions',            to: 'discussions#index', as: :discussions
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

post   'vote/:type/:id/:flag', to: 'votes#create',  as: :create_vote
delete 'vote/:type/:id',       to: 'votes#destroy', as: :destroy_vote
