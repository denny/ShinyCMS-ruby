# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Routes
    # Route extension to add admin area routes for several features in the core plugin
    module AdminArea
      def self.extended( router )
        router.instance_exec do
          get :admin, to: 'admin/root#index'

          scope path: 'admin', module: 'admin' do
            extend ShinyCMS::Routes::AdminConcerns  # with_paging and with_search

            extend ShinyCMS::Routes::Discussions  # comment and discussion admin/moderation

            extend ShinyCMS::Routes::Stats  # stats for web traffic and email opens/clicks

            resources :consent_versions, path: 'consent-versions', except: :index,
                                         concerns: %i[ with_paging with_search ]

            resources :email_recipients, path: 'email-recipients', only: :destroy,
                                         concerns: %i[ with_paging with_search ] do
              put :'do-not-contact', on: :member, to: 'email_recipients#do_not_contact'
            end

            get 'feature-flags', to: 'feature_flags#index'
            put 'feature-flags', to: 'feature_flags#update'

            get 'site-settings', to: 'site_settings#index', as: :admin_site_settings
            put 'site-settings', to: 'site_settings#update'

            resources :users, concerns: %i[ with_paging with_search ], except: %i[ index show ]
            get 'users/usernames', to: 'users#username_search', as: :search_usernames
          end
        end
      end
    end
  end
end
