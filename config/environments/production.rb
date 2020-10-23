# frozen_string_literal: true

Rails.application.configure do
  # Settings here will take precedence over those in config/application.rb

  # The forgery protection seems to false positive a lot around proxies...
  config.action_controller.forgery_protection_origin_check = false

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either
  # ENV["RAILS_MASTER_KEY"] or in config/master.key.
  # This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Check whether we're pushing files up to AWS or storing them on local disk
  config.active_storage.service =
    if ENV['AWS_S3_FILES_BUCKET'].present?
      :amazon
    else
      :local
    end

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins
  #     = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security,
  # and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  # config.log_level = :debug
  # Log at :warn instead of :debug so passwords don't end up in production logs
  config.log_level = :warn

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for ActiveJob
  config.active_job.queue_adapter = :sidekiq
  config.active_job.queue_name_prefix = ENV['SIDEKIQ_PREFIX'] if ENV['SIDEKIQ_PREFIX'].present?

  # config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to
  # raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    # SMTP server - the server you send email through - e.g. smtp.sendgrid.net
    address: ENV['MAILER_ADDRESS'],
    port: ENV['MAILER_PORT'],
    # HELO/EHLO domain - the domain your emails come from - e.g. shinycms.org
    domain: ENV['MAILER_DOMAIN'],
    user_name: ENV['MAILER_USER_NAME'],
    password: ENV['MAILER_PASSWORD'],
    # 'plain', 'login', or 'cram_md5'
    authentication: ( ENV['MAILER_AUTHENTICATION'] || 'plain' ).to_sym
  }
  # The domain name used to construct any URLs in your emails
  config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'] }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger
  #     = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'ShinyCMS')

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new( $stdout )
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new( logger )
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Inserts middleware to perform automatic connection switching.
  # The `database_selector` hash is used to pass options to the DatabaseSelector
  # middleware. The `delay` is used to determine how long to wait after a write
  # to send a subsequent read to the primary.
  #
  # The `database_resolver` class is used by the middleware to determine which
  # database is appropriate to use based on the time delay.
  #
  # The `database_resolver_context` class is used by the middleware to set
  # timestamps for the last write to the primary. The resolver uses the context
  # class timestamps to determine how long to wait before reading from the
  # replica.
  #
  # By default Rails will store a last write timestamp in the session. The
  # DatabaseSelector middleware is designed as such you can define your own
  # strategy for connection switching and pass that into the middleware through
  # these configuration options.
  # config.active_record.database_selector = { delay: 2.seconds }
  # config.active_record.database_resolver
  #     = ActiveRecord::Middleware::DatabaseSelector::Resolver
  # config.active_record.database_resolver_context
  #     = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session
end
