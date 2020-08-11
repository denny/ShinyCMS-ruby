# frozen_string_literal: true

# ============================================================================
# Project:   ShinyProfiles plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyProfiles/lib/tasks/shiny_profiles_tasks.rake
# Purpose:   Rake tasks for ShinyProfiles plugin
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

# To copy and run the database migrations for ShinyProfiles (shiny_profiles table):
# rails shiny_profiles:install:migrations
# rails db:migrate
#
# To install supporting data for ShinyProfiles (feature flag):
# rails shiny_profiles:db:seed
#
# These two tasks can be run in either order.

require 'dotenv/tasks'

namespace :shiny_profiles do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for ShinyProfiles plugin'
    task seed: %i[ environment dotenv ] do
      ShinyProfiles::Engine.load_seed
    end
    # :nocov:
  end
end
