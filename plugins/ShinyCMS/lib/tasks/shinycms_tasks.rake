# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# To copy and run the database migrations for ShinyCMS:
#   rails shiny_cms:install:migrations  # Note the underscore.*
#   rails db:migrate
#
# To install supporting data for ShinyCMS (admin capabilities and feature flags):
#   rails shinycms:db:seed  # Note the lack of underscore.
#
# These two tasks can be run in either order.

namespace :shinycms do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for the ShinyCMS core plugin'
    task seed: %i[ environment dotenv ] do
      ShinyCMS::Engine.load_seed
    end
    # :nocov:
  end
end

# * Rails inflection is an _actual_ nightmare. I know I'm far from being
#   the first person to discover this, but wow.
