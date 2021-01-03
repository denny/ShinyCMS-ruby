# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyProfiles::Engine.routes.draw do
  scope format: false do
    # Main site
    get 'profiles',               to: 'profiles#index'
    get 'profile',                to: 'profiles#profile_redirect', as: :profile_redirect
    get 'profile/:username',      to: 'profiles#show', as: :profile,
                                  constraints: { username: User::USERNAME_REGEX }
    get 'profile/:username/edit', to: 'profiles#edit', as: :edit_profile,
                                  constraints: { username: User::USERNAME_REGEX }

    # Admin area
    scope path: 'admin', module: 'admin' do
      get 'profiles/:id/edit', to: 'profiles#edit',   as: :admin_edit_profile
      put 'profiles/:id',      to: 'profiles#update', as: :admin_profile
    end
  end
end
