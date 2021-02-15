# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Currently only Blazer inherits from this base controller
class ApplicationController < ActionController::Base
  helper ShinyCMS::AdminAreaHelper
  helper ShinyCMS::SidekiqHelper
  helper ShinyCMS::ShinyPluginHelper
  helper ShinyCMS::ShinyUserHelper

  # I like my helpers, thankyouverymuch.
  def self.clear_helpers
    super unless self == Blazer::BaseController
  end

  private

  # Controls access to Blazer features in admin area (set in config/blazer.yml)
  def blazer_authorize
    return true if current_user&.can? :view_charts, :stats

    redirect_to shiny_core.admin_path, alert: t( 'shinycms.admin.blazer.auth_fail' )
  end
end
