# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Base controller for ShinyCMS (see also: MainController, AdminController)
  class ApplicationController < ActionController::Base
    before_action :set_view_paths

    helper_method :shinycms, :recaptcha_v2_site_key, :recaptcha_v3_site_key, :recaptcha_checkbox_site_key

    def self.recaptcha_v3_secret_key
      ENV[ 'RECAPTCHA_V3_SECRET_KEY' ]
    end

    def self.recaptcha_v2_secret_key
      ENV[ 'RECAPTCHA_V2_SECRET_KEY' ]
    end

    def self.recaptcha_checkbox_secret_key
      ENV[ 'RECAPTCHA_CHECKBOX_SECRET_KEY' ]
    end

    # Prevent Blazer from unhelpfully removing all of the ShinyCMS helpers
    def self.clear_helpers
      super unless self == Blazer::BaseController
    end

    private

    def set_view_paths
      # Add the default templates directory to the top of view_paths
      prepend_view_path 'plugins/ShinyCMS/app/views/shinycms'

      # Add the default templates directory for any loaded plugins above that
      ShinyPlugin.with_views.each do |plugin|
        prepend_view_path plugin.view_path
      end
    end

    def blazer_authorize
      return true if current_user&.can? :view_charts, :stats

      redirect_to main_app.admin_path, alert: t( 'admin.blazer.auth_fail' )
    end

    # Rails inflection is Made Of Fail
    def shinycms
      shiny_cms
    end

    def recaptcha_v3_site_key
      ENV[ 'RECAPTCHA_V3_SITE_KEY' ]
    end

    def recaptcha_v2_site_key
      ENV[ 'RECAPTCHA_V2_SITE_KEY' ]
    end

    def recaptcha_checkbox_site_key
      ENV[ 'RECAPTCHA_CHECKBOX_SITE_KEY' ]
    end
  end
end
