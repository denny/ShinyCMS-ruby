# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for main app (ShinyHostApp)

Rails.application.routes.draw do
  if defined? ShinyCMS
    # If ShinyPages is loaded, let it handle the root path
    extend ShinyPages::Routes::RootPage if ShinyCMS.plugins.loaded? :ShinyPages

    # Mount all the routes from ShinyCMS core and feature plugins
    extend ShinyCMS::Routes::Plugins

    # AhoyEmail provides email tracking features
    mount AhoyEmail::Engine, at: '/ahoy'

    # Blazer provides charts and dashboards in the ShinyCMS admin area
    mount Blazer::Engine, at: '/admin/tools/blazer' if defined? Blazer

    # This should be moved into the Shop controller
    mount StripeEvent::Engine, at: '/shop/stripe_events'

    # Protect the /admin namespace from fishing expeditions
    extend ShinyCMS::Routes::Admin404

    # Set up the top-level catch-all route that allows ShinyPages to create
    # and control pages and page sections at the top-level of the main site:
    # https://example.com/hello rather than https://example.com/pages/hello
    #
    # Because this route matches everything that reaches it, it must be defined last!
    extend ShinyPages::Routes::TopLevelPages if ShinyCMS.plugins.loaded? :ShinyPages
  end
end
