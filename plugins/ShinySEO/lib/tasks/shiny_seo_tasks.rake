# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# To copy and run the database migrations for ShinySEO:
#   rails shiny_seo:install:migrations
#   rails db:migrate
#
# To install supporting data for ShinySEO (admin capabilities and feature flags):
#   rails shiny_seo:db:seed
#
# These two tasks can be run in either order.

namespace :shiny_seo do
  namespace :db do
    desc 'ShinyCMS: load supporting data for ShinySEO plugin'
    task seed: %i[ environment dotenv ] do
      # :nocov:
      ShinySEO::Engine.load_seed
      # :nocov:
    end
  end
end
