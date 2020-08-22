# frozen_string_literal: true

# ============================================================================
# Project:   ShinyPages plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyPages/lib/tasks/shiny_pages_tasks.rake
# Purpose:   Rake tasks for ShinyPages plugin
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

# To copy and run the database migrations for ShinyPages:
# rails shiny_pages:install:migrations
# rails db:migrate
#
# To install supporting data for ShinyPages (admin capabilities and feature flags):
# rails shiny_pages:db:seed
#
# These two tasks can be run in either order.

require 'dotenv/tasks'

namespace :shiny_pages do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for ShinyPages plugin'
    task seed: %i[ environment dotenv ] do
      ShinyPages::Engine.load_seed
    end
    # :nocov:
  end
end
