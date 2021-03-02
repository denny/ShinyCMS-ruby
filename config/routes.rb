# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for main app (ShinyHostApp)

require_relative '../plugins/ShinyCMS/lib/import_routes' if defined? ShinyCMS

Rails.application.routes.draw do
  if defined? ShinyCMS
    scope format: false do
      # Currently, if ShinyPages is loaded, then we assume it should control the root path
      import_routes file: :root, plugin: :ShinyPages if ShinyCMS.plugins.loaded? :ShinyPages

      # Mount the ShinyCMS core plugin, and any enabled feature plugins
      import_routes file: :shinycms_plugins

      # Mount engines from gems used to provide various ShinyCMS features
      import_routes file: :engine_routes_for_main_app

      # Protect the /admin namespace from fishing expeditions
      import_routes file: :admin_page_not_found

      # The top-level catch-all route that allows ShinyPages to create and control
      # pages and page sections at the top-level - /hello rather than /pages/hello
      #
      # Because this route matches everything that reaches it, it must be defined last!
      import_routes file: :top_level_pages, plugin: :ShinyPages if ShinyCMS.plugins.loaded? :ShinyPages
    end
  end
end
