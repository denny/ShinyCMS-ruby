# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # ShinyCMS base controller for the admin area
  class AdminController < ApplicationController
    include Pundit

    helper Rails.application.routes.url_helpers

    before_action :check_admin_ip_list
    before_action :authenticate_user!
    before_action :cache_user_capabilities

    after_action :verify_authorized

    layout 'admin/layouts/admin_area'

    def index
      skip_authorization

      if ShinyCMS::Plugins.loaded?( :ShinyPages ) && current_user.can?( :list, :pages )
        redirect_to shiny_pages.pages_path
      else
        redirect_to main_app.root_path
      end
    end

    def not_found
      skip_authorization
      bad_path = params[:path]
      redirect_to admin_path, alert: t( 'shinycms.admin.invalid_url', request_path: bad_path )
    end

    private

    # Check whether a list of permitted admin IP addresses has been defined,
    # and if one has, then redirect anybody not coming from one of those IPs.
    def check_admin_ip_list
      allowed = Setting.get :admin_ip_list
      return if allowed.blank?

      return if allowed.strip.split( /\s*,\s*|\s+/ ).include? request.remote_ip

      redirect_to main_app.root_path
    end

    def cache_user_capabilities
      current_user&.cache_capabilities
    end
  end
end
