# frozen_string_literal: true

# ShinyNews: ShinyCMS news plugin
#
# To install supporting data for ShinyNews (admin capabilities and feature flag):
# rails shiny_news:db:seed
#
# To copy and run the database migrations for ShinyNews:
# rails shiny_news:install:migrations
# rails db:migrate
#
# These two tasks can be run in either order. You will need to do both, in all environments.

require 'dotenv/tasks'

namespace :shiny_news do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for news plugin'
    task seed: %i[ environment dotenv ] do
      ShinyNews::Engine.load_seed
    end
    # :nocov:
  end
end
