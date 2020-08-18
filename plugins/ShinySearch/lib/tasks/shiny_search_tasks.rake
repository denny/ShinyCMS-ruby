# frozen_string_literal: true

# ============================================================================
# Project:   ShinySearch plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinySearch/lib/tasks/shiny_search_tasks.rake
# Purpose:   Rake tasks for ShinySearch plugin
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

# To copy and run the database migrations for ShinySearch:
# rails shiny_search:install:migrations
# rails db:migrate
#
# To install supporting data for ShinySearch (admin capabilities and feature flags):
# rails shiny_search:db:seed
#
# These two tasks can be run in either order.

require 'dotenv/tasks'

namespace :shiny_search do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for ShinySearch plugin'
    task seed: %i[ environment dotenv ] do
      ShinySearch::Engine.load_seed
    end
    # :nocov:
  end
end
