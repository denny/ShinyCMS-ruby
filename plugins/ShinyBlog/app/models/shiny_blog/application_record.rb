# frozen_string_literal: true

# ============================================================================
# Project:   ShinyBlog plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyBlog/app/models/shiny_blog/application_record.rb
# Purpose:   Base class for models
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyBlog
  # Base model class for ShinyBlog plugin for ShinyCMS
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def url_helpers
      ShinyBlog::Engine.routes.url_helpers
    end

    def self.capability_category_name
      'blog_posts'
    end
  end
end
