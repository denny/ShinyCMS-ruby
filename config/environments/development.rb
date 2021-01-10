# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

Rails.application.configure do
  # Settings specified here take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  # config.eager_load = false

  # We need eager load enabled so that we can use .descendants to check all the models
  # for the ones that provide various capabilities - e.g. taggable/searchable/etc
  config.eager_load = true

  # This fixes (or hides?) a problem with theme assets
  config.assets.check_precompiled_asset = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join( 'tmp/caching-dev.txt' ).exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control': "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Blow up for unexpected user auth params in dev
  config.action_controller.action_on_unpermitted_parameters = :raise

  # Check whether we're pushing files up to AWS or storing them on local disk
  if ENV['AWS_S3_FILES_BUCKET'].present?
    config.active_storage.service = :amazon
  else
    config.active_storage.service = :local
  end

  # Allow ActiveJob to use Sidekiq queues in dev
  if ENV['SIDEKIQ_CONCURRENCY'].present?
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = ENV['SIDEKIQ_PREFIX'] if ENV['SIDEKIQ_PREFIX'].present?
  end

  # We use letter_opener_web to catch all emails sent in dev
  # You can view them at http://localhost:3000/dev/outbox
  config.action_mailer.perform_deliveries = true
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  config.i18n.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
