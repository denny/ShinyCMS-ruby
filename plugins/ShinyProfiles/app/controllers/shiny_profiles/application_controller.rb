# frozen_string_literal: true

# ============================================================================
# Project:   ShinyProfiles plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyProfiles/app/controllers/shiny_profiles/application_controller.rb
# Purpose:   Base controller for main site
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyProfiles
  # Main site base controller for ShinyProfiles plugin for ShinyCMS
  # Inherits from ShinyCMS ApplicationController
  class ApplicationController < ::MainController
    helper Rails.application.routes.url_helpers
  end
end
