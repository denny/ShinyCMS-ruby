# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require_relative 'boot'

require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'

require 'action_controller/railtie'
require 'action_mailer/railtie'      # Outgoing email (user accounts, comment replies, etc)
# require "action_mailbox/engine"    # Incoming email
require 'action_text/engine'         # Rich Text / Trix
require 'action_view/railtie'
# require "action_cable/engine"

require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require( *Rails.groups )

module ShinyHostApp
  # Rails application class for the ShinyHostApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib( ignore: %w[ assets generators tasks ] )

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Add autoloaded paths into `$LOAD_PATH`
    config.add_autoload_paths_to_load_path = true

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Smarter error pages
    config.exceptions_app = routes
  end
end
