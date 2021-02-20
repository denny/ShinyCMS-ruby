# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Should be: ShinyHostApp base controller
# Currently: Faux ShinyCMS admin area base controller for Blazer to inherit from
class ApplicationController < ActionController::Base
  #
  # This main_app application controller only exists to make it possible to load
  # Blazer and embed it into the ShinyCMS admin area - which is why it loads the
  # admin helper. Overall, this feels like a security mistake waiting to happen.
  #
  # TODO: Find a better way to embed Blazer, without (ab)using the host app.

  helper ShinyCMS::AdminAreaHelper

  helper ShinyCMS::PluginHelper
  helper ShinyCMS::SidekiqHelper
  helper ShinyCMS::ShinyUserHelper

  # Prevent Blazer from unloading all of the ShinyCMS helpers
  def self.clear_helpers; end

  private

  # Control access to Blazer (method name set in config/blazer.yml)
  def blazer_authorize
    return true if current_user&.can? :view_charts, :stats

    redirect_to shinycms.admin_path, alert: t( 'shinycms.admin.blazer.auth_fail' )
  end
end
