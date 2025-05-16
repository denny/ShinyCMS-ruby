# frozen_string_literal: true

# To copy and run the database migrations for ShinyShop:
# rails shiny_shop:install:migrations
# rails db:migrate
#
# To install supporting data for ShinyShop (admin capabilities and feature flags):
# rails shiny_shop:db:seed
#
# These two tasks can be run in either order.

require 'dotenv/tasks'

namespace :shiny_shop do
  namespace :db do
    # :nocov:
    desc 'ShinyCMS: load supporting data for ShinyShop plugin'
    task seed: %i[ environment dotenv ] do
      ShinyShop::Engine.load_seed
    end
    # :nocov:
  end
end
