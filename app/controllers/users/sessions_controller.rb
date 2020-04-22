# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/users/sessions_controller.rb
# Purpose:   User login controller; almost entirely handled by Devise
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Users::SessionsController < Devise::SessionsController
  before_action :check_feature_flags

  skip_after_action :track_ahoy_visit

  private

  def check_feature_flags
    enforce_feature_flags :user_login
  end
end
