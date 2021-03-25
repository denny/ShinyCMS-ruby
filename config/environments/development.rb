# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Enable and configure Bullet (reports on N+1 queries and related issues)
  config.after_initialize do
    Bullet.enable        = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.bullet_logger = true
    Bullet.add_footer    = true
    # Bullet.alert       = true  # Pop up JavaScript alert dialogues for each issue found
    # Bullet.raise       = true  # Raise an error if any issues are found during
  end

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # ShinyCMS needs eager load enabled so that we can use .descendants to check all the models
  # in each plugin for the ones that provide various capabilities - e.g. taggable, demo_data, etc
  config.eager_load = true
  config.rake_eager_load = true

  # This fixes (or hides?) a problem with theme assets
  config.assets.check_precompiled_asset = false

  # Show full error reports.
  config.consider_all_requests_local = true     # standard dev behaviour
  # config.consider_all_requests_local = false  # behave like production

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

  # Make unpermitted params nice and conspicuous during development
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

  # Use letter_opener_web to catch all emails sent in dev
  # You can view them at http://localhost:3000/dev/tools/outbox
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method     = :letter_opener_web
  config.action_mailer.perform_deliveries  = true
  config.action_mailer.perform_caching     = false

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log
  # Raise exceptions for disallowed deprecations
  config.active_support.disallowed_deprecation = :raise
  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error for missing translation data
  config.i18n.raise_on_missing_translations = true

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = false

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Debug mode disables concatenation and preprocessing of assets
  # This option may cause significant delays in view rendering with a large number of complex assets
  # config.assets.debug = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
