# frozen_string_literal: true

# ============================================================================
# Project:   ShinyNews plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyNews/app/models/shiny_news/application_record.rb
# Purpose:   Base class for models
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyNews
  # Base model class for ShinyNews plugin for ShinyCMS
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def url_helpers
      ShinyNews::Engine.routes.url_helpers
    end

    def human_name
      self.class.name.underscore.gsub( '/', '_' ).gsub( 'shiny_', '' ).humanize.downcase
    end
  end
end
