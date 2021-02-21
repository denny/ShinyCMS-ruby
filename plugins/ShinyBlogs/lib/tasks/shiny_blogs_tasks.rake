# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# To copy and run the database migrations for ShinyBlogs:
# rails shiny_blogs:install:migrations
# rails db:migrate
#
# To install supporting data for ShinyBlogs (admin capabilities and feature flags):
# rails shiny_blogs:db:seed
#
# These two tasks can be run in either order.

namespace :shiny_blogs do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for ShinyBlogs plugin'
    task seed: %i[ environment dotenv ] do
      ShinyBlogs::Engine.load_seed
    end
    # :nocov:
  end
end
