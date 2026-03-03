# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    module Tools
      # Base class to inherit from in the controller that Blazer then inherits from
      # (this is currently /app/controllers/blazer/application.rb in ShinyHostApp)
      # to allow Blazer to be embedded within the ShinyCMS admin area
      class BlazerBaseController < BaseController
        # Helpers required to build the admin area UI - notably, the side menu
        helper ShinyCMS::AdminAreaHelper
        helper ShinyCMS::PluginsHelper
        helper ShinyCMS::UsersHelper

        # Make ShinyHostApp url_helpers available to Blazer's views
        helper ShinyCMS::RouteDelegator

        # Prevent Blazer from immediately removing all the useful stuff we just added
        def self.clear_helpers; end

        private

        # Control access to Blazer (configured in config/blazer.yml)
        def blazer_authorize
          return true if current_user&.can? :use_blazer, :tools

          redirect_to shinycms.admin_path, alert: t( 'shinycms.admin.blazer.auth_fail' )
        end
      end
    end
  end
end
