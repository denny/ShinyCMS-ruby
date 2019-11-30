require_relative 'boot'

# Replace this:
# require 'rails/all'
# ... with this stack of individual require statements (so I can get selective)

require 'rails'

require 'action_cable/engine'       # Why do I need this?
require 'action_controller/railtie' # Pretty sure we need this though
# require 'action_mailbox/engine'   # Won't need for a long time: inbound email
require 'action_mailer/railtie'     # Registration emails, etc
# require 'action_text/engine'
require 'action_view/railtie'       # Also seems quite fundamental
require 'active_job/railtie'        # Queue (for mailer tasks)
require 'active_record/railtie'
# require 'active_storage/engine'   # Will need soon: user profile pics, etc
# require 'rails/test_unit/railtie'
# require 'sprockets/railtie'

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

    # Support for themes on main (user-facing) site
    config.theme_name = 'shinycms'
    theme_name = ENV['SHINYCMS_THEME'] || 'shinycms'
    path_parts = %W[ app views themes #{theme_name} ]
    theme_dir = Rails.root.join( *path_parts )
    if File.directory? theme_dir
      layout_file = Rails.root.join(
        *path_parts, 'layouts', "#{theme_name}.html.erb"
      )
      config.theme_name = theme_name if File.file? layout_file
    end

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
