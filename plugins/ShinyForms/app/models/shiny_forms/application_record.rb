# frozen_string_literal: true

# ============================================================================
# Project:   ShinyForms plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyForms/app/models/shiny_forms/application_record.rb
# Purpose:   Base class for models
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
module ShinyForms
  # Base model class for ShinyForms plugin for ShinyCMS
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
