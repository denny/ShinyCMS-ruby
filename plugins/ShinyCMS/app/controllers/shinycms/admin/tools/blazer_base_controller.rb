# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# rubocop:disable Rails/ApplicationController
module ShinyCMS
  module Admin
    module Tools
      # Base class to inherit from in the controller that Blazer then inherits
      # from. Unfortunately, by default this is main app's ApplicationController,
      # which you really don't want all this Admin stuff in. :-\
      class BlazerBaseController < ActionController::Base
        include Pundit

        include ShinyCMS::FeatureFlags

        # Helpers required to build the admin area UI - notably, the side menu
        helper ShinyCMS::AdminAreaHelper
        helper ShinyCMS::PluginsHelper
        helper ShinyCMS::UsersHelper

        # Make ShinyHostApp url_helpers available to Blazer's views
        helper ShinyCMS::RouteDelegator

        before_action :check_admin_ip_list
        before_action :authenticate_user!

        after_action :verify_authorized

        # Prevent Blazer from immediately removing all the useful stuff we just added
        def self.clear_helpers; end

        private

        # Control access to Blazer (configured in config/blazer.yml)
        def blazer_authorize
          return true if current_user&.can? :use_blazer, :tools

          redirect_to shinycms.admin_path, alert: t( 'shinycms.admin.blazer.auth_fail' )
        end

        # Check whether a list of permitted admin IP addresses has been defined,
        # and if one has, then redirect anybody not coming from one of those IPs.
        def check_admin_ip_list
          allowed = Setting.get :admin_ip_list
          return if allowed.blank?

          return if allowed.strip.split( /\s*,\s*|\s+/ ).include? request.remote_ip

          redirect_to main_app.root_path
        end
      end
    end
  end
end
# rubocop:enable Rails/ApplicationController
