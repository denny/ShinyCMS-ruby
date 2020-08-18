# frozen_string_literal: true

# ============================================================================
# Project:   ShinyForms plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyForms/app/controllers/shiny_forms/admin_controller.rb
# Purpose:   Base controller for admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyForms
  # Base controller for admin features of ShinyForms plugin for ShinyCMS
  # Inherits from ShinyCMS AdminController
  class AdminController < ::AdminController
    helper Rails.application.routes.url_helpers
  end
end
