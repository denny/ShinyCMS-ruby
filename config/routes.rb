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
    # Currently, if ShinyPages is loaded, then we assume it should control the root path
    extend ShinyPages::Routes::RootPage if ShinyCMS.plugins.loaded? :ShinyPages

    import_routes partial: :php_is_a_bad_request

    import_routes partial: :mount_shinycms_core_plugin

    import_routes partial: :mount_shinycms_feature_plugins

    # Engines from gems that ShinyCMS uses to provide various features
    import_routes partial: :mount_other_engines_in_main_app

    # Protect the /admin namespace from fishing expeditions
    import_routes partial: :admin_page_not_found

    # Set up the top-level catch-all route that allows ShinyPages to create
    # and control pages and page sections at the top-level of the main site:
    # https://example.com/hello rather than https://example.com/pages/hello
    #
    # Because this route matches everything that reaches it, it must be defined last!
    # import_routes partial: :top_level_pages, plugin: :ShinyPages if ShinyCMS.plugins.loaded? :ShinyPages
    extend ShinyPages::Routes::TopLevelPages if ShinyCMS.plugins.loaded? :ShinyPages
  end
end
