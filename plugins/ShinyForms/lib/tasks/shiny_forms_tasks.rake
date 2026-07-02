# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# To install supporting data for Forms (admin capabilities and feature flag):
# rails shiny_forms:db:seed
#
# To copy and run the database migrations for Forms:
# rails shiny_forms:install:migrations
# rails db:migrate
#
# These two tasks can be run in either order. You will need to do both, in all environments.

namespace :shiny_forms do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for forms plugin'
    task seed: %i[ environment dotenv ] do
      ShinyForms::Engine.load_seed
    end
    # :nocov:
  end
end
