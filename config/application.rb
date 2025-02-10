# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
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
# require "action_text/engine"       # Rich Text / Trix
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
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Smarter error pages
    config.exceptions_app = routes

    # Disables the deprecated #to_s override in some Ruby core classes. For more information see
    # https://guides.rubyonrails.org/configuring.html#config-active-support-disable-to-s-conversion
    # config.active_support.disable_to_s_conversion = true

    # Changing this default means that all new cache entries added to the cache will have a
    # different format that is not supported by Rails 6.1 applications. Only change this value
    # after your application is fully deployed to Rails 7.0 and you have no plans to rollback.
    # When you're ready to change format, uncomment this:
    # config.active_support.cache_format_version = 7.0

    # To migrate an existing application to the `:json` serializer, use the `:hybrid` option.
    # It is fine to use `:hybrid` long term; you should do that until you're confident *all*
    # your cookies have been converted to JSON. To keep using `:hybrid` long term, move this
    # config to its own initializer or to `config/application.rb`.
    # config.action_dispatch.cookies_serializer = :hybrid
  end
end
