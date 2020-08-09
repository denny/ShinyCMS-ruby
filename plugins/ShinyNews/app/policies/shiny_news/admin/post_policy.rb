# frozen_string_literal: true

# ============================================================================
# Project:   ShinyNews plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyNews/app/models/shiny_news/post.rb
# Purpose:   Pundit policy for admin area features
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyNews
  # Inherits from ShinyCMS default admin policy
  class Admin::PostPolicy < ::Admin::DefaultPolicy
  end
end
