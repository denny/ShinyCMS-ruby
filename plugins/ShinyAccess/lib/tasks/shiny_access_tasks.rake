# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# To copy and run the database migrations for ShinyAccess:
# rails shiny_access:install:migrations
# rails db:migrate
#
# To install supporting data for ShinyAccess (admin capabilities and feature flags):
# rails shiny_access:db:seed
#
# These two tasks can be run in either order.

namespace :shiny_access do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for ShinyAccess plugin'
    task seed: %i[ environment dotenv ] do
      ShinyAccess::Engine.load_seed
    end
    # :nocov:
  end
end
