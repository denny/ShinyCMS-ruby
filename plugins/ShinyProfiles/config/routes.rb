# frozen_string_literal: true

# ============================================================================
# Project:   ShinyProfiles plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyProfiles/config/routes.rb
# Purpose:   Routes for ShinyProfiles plugin
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

ShinyProfiles::Engine.routes.draw do
  get 'profiles',           to: 'profiles#index'
  get 'profile/:username',  to: 'profiles#show', as: :profile,
                            constraints: { username: User::USERNAME_REGEX }
  get 'profile',            to: 'profiles#profile_redirect', as: :profile_redirect
end
