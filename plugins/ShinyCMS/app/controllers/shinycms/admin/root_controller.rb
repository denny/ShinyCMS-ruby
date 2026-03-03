# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # ShinyCMS controller for the /admin redirect and the admin area 404 handler
  class Admin::RootController < ApplicationController
    include ShinyCMS::Admin::AccessControlByIP

    before_action :authenticate_user!

    def index
      flash.keep

      if ShinyCMS.plugins.loaded?( :ShinyPages ) && current_user.can?( :list, :pages )
        redirect_to shiny_pages.pages_path
      else
        redirect_to main_app.root_path
      end
    end

    def not_found
      bad_path = params[:path]

      redirect_to admin_path, alert: t( 'shinycms.admin.invalid_url', request_path: bad_path )
    end
  end
end
