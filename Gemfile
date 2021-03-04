# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require_relative 'lib/gemfile_plugins_helper'

source 'https://rubygems.org' do
  # Ruby 3.0
  ruby '~> 3.0.0'

  # Rails 6.1
  gem 'rails', '~> 6.1.3'

  # Load ENV from .env(.*) files
  gem 'dotenv-rails', require: 'dotenv/rails-now'

  # Find out which bits of your code are used more/less in production
  gem 'coverband', groups: %i[ development production ]

  # ShinyCMS core plugin
  gem 'shinycms', path: 'plugins/ShinyCMS'

  # ShinyCMS feature plugins
  plugin_names.each do |plugin_name|
    gem_name = underscore( plugin_name )
    gem gem_name, path: "plugins/#{plugin_name}"
  end

  # Postgres
  gem 'pg', '~> 1.2.3'

  # Webserver
  gem 'puma', '~> 5.2', groups: %i[ development production ]

  # Sessions
  # FIXME: Installing from GitHub because Ruby 3 support is merged but not released:
  # https://github.com/rails/activerecord-session_store/pull/159
  # https://github.com/rails/activerecord-session_store/issues/171
  gem 'activerecord-session_store', git: 'https://github.com/rails/activerecord-session_store'

  # Email previews
  gem 'rails_email_preview'

  # Email stats
  gem 'ahoy_email'
  # Web stats
  gem 'ahoy_matey'

  # Charts and dashboards
  gem 'blazer'
  # Charts
  gem 'chartkick', '~> 3.4.2'

  group :development, :test do
    # Run tests
    gem 'rspec-rails'

    # Tools for working with translation strings
    # gem 'i18n-debug'
    gem 'i18n-tasks', '~> 0.9.33'
  end

  group :development do
    # Linting: general
    gem 'rubocop'
    # Linting: performance tweaks
    gem 'rubocop-performance'
    # Linting: Rails-specific
    gem 'rubocop-rails'
    # Linting: test suite
    gem 'rubocop-rspec'

    # Manage git hooks
    gem 'overcommit'

    # Add .analyze method to ActiveRecord objects
    gem 'activerecord-analyze'

    # Capture all emails sent by the system, and view them in a dev webmail inbox
    gem 'letter_opener_web', '~> 1.0'

    # Reload dev server when files change
    gem 'listen', '~> 3.3'

    # Analysis tools for postgres
    gem 'rails-pg-extras'

    # Used to generate demo site data
    gem 'seed_dump'
  end

  group :test do
    # Wipe the test database before each test run
    gem 'database_cleaner-active_record'

    # Create test objects
    gem 'factory_bot_rails'
    # Fill test objects with fake data
    gem 'faker'

    # Integration tests (request specs)
    gem 'capybara', '>= 2.15'

    # Intercept calls to external services (notably, the Algolia API)
    gem 'webmock'

    # Analyse and report on test coverage via CodeCov
    gem 'codecov', require: false
    # Rspec report formatter for Codecov
    gem 'rspec_junit_formatter'

    # Show test failure details instantly, in-line with progress dots
    gem 'rspec-instafail'
  end
end
