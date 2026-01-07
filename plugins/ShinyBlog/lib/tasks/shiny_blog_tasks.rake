# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# To copy and run the database migrations for ShinyBlog (shiny_blog_posts table):
# rails shiny_blog:install:migrations
# rails db:migrate
#
# To install supporting data for ShinyBlog (admin capabilities and feature flag):
# rails shiny_blog:db:seed
#
# These two tasks can be run in either order.

namespace :shiny_blog do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for ShinyBlog plugin'
    task seed: %i[ environment dotenv ] do
      ShinyBlog::Engine.load_seed
    end
    # :nocov:
  end
end
