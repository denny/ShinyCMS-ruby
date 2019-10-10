require_relative 'boot'

require 'rails/all'

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
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Remove routes for Active Storage
    initializer(
      :remove_activestorage_routes, after: :add_routing_paths
    ) do |app|
      app.routes_reloader.paths.delete_if do |path|
        path =~ /activestorage/
      end
    end
    # Remote routes for Action Mailbox
    initializer(
      :remove_actionmailbox_routes, after: :add_routing_paths
    ) do |app|
      app.routes_reloader.paths.delete_if do |path|
        path =~ /actionmailbox/
      end
    end
  end
end
