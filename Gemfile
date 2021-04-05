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

  # Email previews
  gem 'rails_email_preview'

  # Email stats
  gem 'ahoy_email', '>= 1.1', '< 2.0'
  # Web stats
  gem 'ahoy_matey'

  # Charts and dashboards
  gem 'blazer'
  # Charts
  gem 'chartkick', '~> 4.0.0'

  group :development, :test do
    # RSpec for Rails
    gem 'rspec-rails'

    # Run tests in parallel
    gem 'parallel_tests'

    # "No silver bullet"
    gem 'bullet'

    # Tools for working with translation strings
    # gem 'i18n-debug'
    gem 'i18n-tasks', '~> 0.9.33'
  end

  group :development do
    # Capture all outgoing emails, with webmail interface to look at them
    gem 'letter_opener_web', '~> 1.0'

    # Reload dev server when files change
    gem 'listen', '~> 3.5'

    # Linting: general
    gem 'rubocop', require: false
    # Linting: performance tweaks
    gem 'rubocop-performance', require: false
    # Linting: Rails-specific
    gem 'rubocop-rails', require: false
    # Linting: test suite
    gem 'rubocop-rspec', require: false

    # Code quality: Ruby Critic
    gem 'rubycritic', '~> 4.6.1', require: false
    # Code quality: Rails Best Practices
    gem 'rails_best_practices', require: false

    # Security: static code analysis
    gem 'brakeman', require: false
    # Security: check gem versions for reported security issues
    gem 'bundler-audit', require: false

    # Add .analyze method to ActiveRecord objects
    gem 'activerecord-analyze'

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
    gem 'capybara', '>= 2.15'

    # Intercept calls to external services (notably, the Algolia API)
    gem 'webmock'

    # Analyse and report on test coverage
    gem 'simplecov', '0.21.2'
    # Analyse and report on test coverage via CodeCov
    gem 'codecov', require: false
    # Rspec report formatter for Codecov
    gem 'rspec_junit_formatter'

    # Show test failure details instantly, in-line with progress dots
    gem 'rspec-instafail'
  end
end
