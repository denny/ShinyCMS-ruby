# frozen_string_literal: true

# ============================================================================
# Project:   ShinyInserts plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyInserts/lib/tasks/shiny_inserts_tasks.rake
# Purpose:   Rake tasks for ShinyInserts plugin
#
# Copyright 2009-2020 Denny de la Haye (https://denny.me)
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

# To copy and run the database migrations for ShinyInserts:
# rails shiny_inserts:install:migrations
# rails db:migrate
#
# To install supporting data for ShinyInserts (admin capabilities and default set):
# rails shiny_inserts:db:seed
#
# These two tasks can be run in either order.

require 'dotenv/tasks'

namespace :shiny_inserts do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for ShinyInserts plugin'
    task seed: %i[ environment dotenv ] do
      ShinyInserts::Engine.load_seed
    end
    # :nocov:
  end
end
