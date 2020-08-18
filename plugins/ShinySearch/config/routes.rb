# frozen_string_literal: true

# ============================================================================
# Project:   ShinySearch plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinySearch/config/routes.rb
# Purpose:   Routes for ShinySearch plugin
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

ShinySearch::Engine.routes.draw do
  scope format: false do
    # Main site
    get  'search', to: 'search#index'
    post 'search', to: 'search#index'
  end
end
