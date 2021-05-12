# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Configuration for Sail (settings engine)

Rails.application.config.to_prepare do
  # Make Sail appear inside our admin UI
  ::Sail::ApplicationController.prepend_view_path 'plugins/ShinyCMS/app/views/shinycms'
  ::Sail::ApplicationController.layout 'admin/layouts/admin_area'

  # Make the main_app url helpers available to Sail's views
  ::Sail::ApplicationController.helper ShinyCMS::RouteDelegator

  # Other helpers used in ShinyCMS admin area views (menus, breadcrumbs, etc)
  ::Sail::ApplicationController.helper ShinyCMS::AdminAreaHelper
  ::Sail::ApplicationController.helper ShinyCMS::PluginsHelper
  ::Sail::ApplicationController.helper ShinyCMS::UsersHelper
  ::Sail::ApplicationController.helper ShinyCMS::ViewComponentHelper
end

Sail.configure do |config|
  config.dashboard_auth_lambda = -> { redirect_to( '/admin' ) unless current_user&.can?( :edit, :settings ) }

  config.back_link_path = nil

  config.cache_life_span = 72.hours
  config.days_until_stale = nil

  ## Defaults
  # Defines an authorization lambda to access the dashboard as a before action.
  # Rendering or redirecting is included here if desired.
  # config.dashboard_auth_lambda = nil
  # Path method as string for the "Main app" button in the dashboard.
  # Any non-existent path will make the button disappear
  # config.back_link_path = 'root_path'
  # How long to cache the Sail.get response for (note that cache is deleted after a set)
  # config.cache_life_span = 6.hours
  # Days with no updates until a setting is considered stale and is a candidate to be removed from code
  # (leave nil to disable checks)
  # config.days_until_stale = 60
  # Number of times Sail.get can fail with unexpected errors until resetting the setting value
  # config.failures_until_reset = 50
  # Enables search auto submit after 2 seconds without typing
  # config.enable_search_auto_submit = true
  # Default separator for array settings
  # config.array_separator = ';'
  # Enable logging for update and reset actions. Logs include
  # timestamp, setting name, new value and author_user_id (if current_user is defined)
  # config.enable_logging = true
end
