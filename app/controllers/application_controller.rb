# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Base controller for ShinyCMS (see also: main_controller, admin_controller)
class ApplicationController < ActionController::Base
  helper_method :recaptcha_v2_site_key,
                :recaptcha_v3_site_key,
                :recaptcha_checkbox_site_key

  def self.recaptcha_v3_secret_key
    ENV[ 'RECAPTCHA_V3_SECRET_KEY' ]
  end

  def self.recaptcha_v2_secret_key
    ENV[ 'RECAPTCHA_V2_SECRET_KEY' ]
  end

  def self.recaptcha_checkbox_secret_key
    ENV[ 'RECAPTCHA_CHECKBOX_SECRET_KEY' ]
  end

  private

  def current_user_can_view_charts?
    return true if current_user&.can? :view_charts, :stats

    redirect_to main_app.admin_path, alert: t( 'admin.blazer.auth_fail' )
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
