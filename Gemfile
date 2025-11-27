# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require_relative 'plugins/ShinyCMS/lib/shinycms/gemfile_helper'
helper = ShinyCMS::GemfileHelper.new

ruby file: '.ruby-version'

source 'https://rubygems.org'
source 'https://rubygems.org' do
  # Rails 8.0
  gem 'rails', '~> 8.0.4'

  # Load ENV from .env(.*) files
  gem 'dotenv-rails', require: 'dotenv/load'

  # Find out which bits of your code are used more/less in production
  gem 'coverband', groups: %i[ production development ]

  # ShinyCMS core plugin
  gem 'shinycms', path: 'plugins/ShinyCMS'

  # ShinyCMS feature plugins
  helper.plugin_names.each do |plugin_name|
    gem_name = helper.underscore( plugin_name )
    gem gem_name, path: "plugins/#{plugin_name}"
  end

  # Postgres
  gem 'pg', '~> 1.6.2'

  # Rack
  gem 'rack', '~> 3.2.4'
  # Rack Session
  gem 'rack-session', '~> 2.1.1'

  # Webserver
  gem 'puma', '~> 7.1', groups: %i[ development production ]

  # Email previews
  gem 'rails_email_preview'

  # Email stats
  gem 'ahoy_email', '>= 1.1', '< 2.0'
  # Web stats
  gem 'ahoy_matey'

  # Charts and dashboards
  gem 'blazer'
  # Charts
  gem 'chartkick', '~> 5.2.1'

  # Stripe
  # gem 'stripe'
  gem 'stripe_event'

  # Request filtering
  gem 'rack-attack'

  group :development, :test do
    # RSpec for Rails
    gem 'rspec-rails'

    # Mutation testing
    gem 'mutant-rspec', require: false

    # Run tests in parallel
    gem 'parallel_tests'

    # "No silver bullet"
    gem 'bullet'

    # Tools for working with translation strings
    # gem 'i18n-debug'
    gem 'i18n-tasks', '~> 1.1.2'
  end

  group :development do
    # Check plugin boundaries
    gem 'packwerk', '~> 3.2'

    # Capture all outgoing emails, with webmail interface to look at them
    gem 'letter_opener_web', '~> 3.0'

    # Reload dev server when files change
    gem 'listen', '~> 3.9'

    # Linting: general
    gem 'rubocop', require: false
    # Linting: Rails-specific
    gem 'rubocop-rails', require: false
    # Linting: test suite
    gem 'rubocop-rspec', require: false
    # Linting: rails tests
    gem 'rubocop-rspec_rails', require: false
    # Linting: test factories
    gem 'rubocop-factory_bot', require: false
    # Linting: feature specs
    gem 'rubocop-capybara', require: false
    # Linting: thread safety
    gem 'rubocop-thread_safety', require: false
    # Linting: performance tweaks
    gem 'rubocop-performance', require: false

    # Code quality: Ruby Critic
    gem 'rubycritic', '~> 4.8.0', require: false

    # Security: static code analysis
    gem 'brakeman', require: false
    # Security: check gem versions for reported security issues
    gem 'bundler-audit', require: false

    # Add .analyze method to ActiveRecord objects
    # gem 'activerecord-analyze'

    # Analysis tools for postgres
    gem 'rails-pg-extras', require: false

    # Manage git hooks
    gem 'overcommit', require: false
  end

  group :test do
    # Wipe the test database before each test run
    gem 'database_cleaner-active_record'

    # Create test objects
    gem 'factory_bot_rails'

    # Generate test data
    gem 'faker'

    # Integration tests (request specs)
    gem 'capybara', '~> 3.40'

    # Intercept calls to external services (notably, the Algolia API)
    gem 'webmock'

    # Analyse and report on test coverage
    gem 'simplecov'
    # Analyse and report on test coverage via CodeCov
    gem 'codecov', require: false
    # Rspec report formatter for Codecov
    gem 'rspec_junit_formatter'

    # Show test failure details instantly, in-line with progress dots
    gem 'rspec-instafail'

    # Because it made me smile.
    gem 'rspec_pacman_formatter'
  end
end
