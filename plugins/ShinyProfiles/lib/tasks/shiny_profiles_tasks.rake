# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# To copy and run the database migrations for ShinyProfiles (shiny_profiles table):
# rails shiny_profiles:install:migrations
# rails db:migrate
#
# To install supporting data for ShinyProfiles (feature flag):
# rails shiny_profiles:db:seed
#
# These two tasks can be run in either order.

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
