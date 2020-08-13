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

ShinyForms::Engine.routes.draw do
  scope format: false do
    # Main site
    post 'form/:slug', to: 'forms#process_form', as: :process_form

    # Admin area
    scope path: 'admin', module: 'admin' do
      resources :forms, except: :show
    end
  end
end
