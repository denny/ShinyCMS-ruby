# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# To copy and run the database migrations for ShinyNewsletters:
# rails shiny_newsletters:install:migrations
# rails db:migrate
#
# To install supporting data for ShinyNewsletters (admin capabilities and feature flags):
# rails shiny_newsletters:db:seed
#
# These two tasks can be run in either order.

namespace :shiny_newsletters do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for ShinyNewsletters plugin'
    task seed: %i[ environment dotenv ] do
      ShinyNewsletters::Engine.load_seed
    end
    # :nocov:
  end
end
