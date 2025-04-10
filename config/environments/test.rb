# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# The test environment is used exclusively to run your application's test suite.
# You never need to work with it otherwise. Remember that your test database is
# "scratch space" for the test suite and is wiped and recreated between test runs.
# Don't rely on the data there!

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Enable and configure Bullet (reports on N+1 queries and related issues)
  config.after_initialize do
    Bullet.enable        = true
    Bullet.bullet_logger = true
    # Bullet.raise       = true  # Raise an error if n+1 query is found during test run
  end

  # ShinyCMS needs eager load enabled, for ActiveRecord::Base.descendants to work properly
  # (Used to find models that have various capabilities - e.g. taggable/searchable/etc)
  config.eager_load = true

  # Show full error reports
  config.consider_all_requests_local = true

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable caching
  config.action_controller.perform_caching = false
  config.action_mailer.perform_caching = false
  config.cache_classes = false
  config.cache_store = :null_store

  # This fixes (or hides?) a problem with plugin assets
  config.assets.check_precompiled_asset = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control': "public, max-age=#{1.hour.to_i}"
  }

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Use test queue for jobs
  config.active_job.queue_adapter = :test

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method adds them to ActionMailer::Base.deliveries instead
  config.action_mailer.default_url_options = { host: 'www.example.com' }
  config.action_mailer.delivery_method = :test

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr
  # Raise exceptions for disallowed deprecations
  config.active_support.disallowed_deprecation = :raise
  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise error for missing translations.
  config.i18n.raise_on_missing_translations = true

  # Don't do MX lookups when running tests
  EmailAddress::Config.configure( host_validation: :syntax )
end
