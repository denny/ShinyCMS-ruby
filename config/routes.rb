# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for main app (ShinyHostApp)

Rails.application.routes.draw do
  scope format: false do
    if defined? ShinyCMS
      # Currently, if ShinyPages is loaded, then we assume it controls the root path
      # require "#{ShinyPages::Engine.root}/route_helpers/root_path_route" if defined? ShinyPages
      root to: 'shiny_pages/pages#index' if defined? ShinyPages

      # ShinyCMS core plugin
      mount ShinyCMS::Engine, at: '/'

      # ShinyCMS feature plugins
      # require "#{ShinyCMS::Engine.root}/route_helpers/mount_all_plugins"
      ShinyCMS::Plugin.loaded.each do |plugin|
        mount plugin.engine, at: '/' if plugin.engine.present?
      end

      ## Other engines used by ShinyCMS

      # AhoyEmail provides email tracking features
      mount AhoyEmail::Engine, at: '/ahoy'

      # Blazer provides charts and dashboards in the ShinyCMS admin area
      mount Blazer::Engine, at: '/admin/stats' if defined? Blazer

      # REP provides previews of site-generated emails in the ShinyCMS admin area
      mount RailsEmailPreview::Engine, at: '/admin/email-previews'

      # Protect the /admin namespace from fishing expeditions
      # require "#{ShinyCore::Engine.root}/route_helpers/catch_all_admin_route"
      match '/admin/*path', to: 'shinycms/admin#not_found', as: :admin_not_found, via: %i[ get post put patch delete ]

      # This catch-all route matches anything and everything not already matched by a route
      # defined before it. It enables the ShinyPages plugin to create pages and sections at
      # the top level of the site - i.e. /foo instead of /pages/foo
      #
      # Because this route matches everything that reaches it, it must be defined last.
      # require "#{ShinyPages::Engine.root}/route_helpers/catch_all_root_route" if defined? ShinyPages
      get '*path', to: 'shiny_pages/pages#show', constraints: lambda { |request|
        !request.path.starts_with?( '/rails/active_' )
      }
    end
  end
end
