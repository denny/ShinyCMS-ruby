# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require_relative 'boot'

# Load Rails components selectively
require 'rails'
# require 'action_cable/engine'
require 'action_controller/railtie'
# require 'action_mailbox/engine'   # Won't need for a long time (inbound email)
require 'action_mailer/railtie'     # Outbound email (registration, etc)
# require 'action_text/engine'
require 'action_view/railtie'
require 'active_job/railtie'        # Queue (for mailer tasks)
require 'active_record/railtie'
require 'active_storage/engine'     # File storage (CKEditor image uploads, etc)
# require 'rails/test_unit/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShinyCMS
  # Application Config
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those set here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after
    # loading the framework and any gems in your application.

    # Remove routes for Action Mailbox (just to make `rails routes` more readable)
    initializer(
      :remove_actionmailbox_routes, after: :add_routing_paths
    ) do |app|
      app.routes_reloader.paths.delete_if do |path|
        path.include? 'actionmailbox'
      end
    end
  end
end
