# frozen_string_literal: true

# ============================================================================
# Project:   ShinyForms plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyForms/app/controllers/shiny_forms/application_controller.rb
# Purpose:   Base controller for main site
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyForms
  # Main site base controller for ShinyForms plugin for ShinyCMS
  # Inherits from ShinyCMS ApplicationController
  class ApplicationController < ::ApplicationController
    helper Rails.application.routes.url_helpers
  end
end
