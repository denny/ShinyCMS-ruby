# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require_relative 'lib/gemfile_plugins_helper'

source 'https://rubygems.org' do
  # Rails 6.1
  gem 'rails', '~> 6.1.1'

  # Postgres
  gem 'pg', '~> 1.2.3'

  # Webserver
  gem 'puma', '~> 5.1', groups: %i[ development production ]

  # Load ENV from .env(.*) files
  gem 'dotenv-rails'

  # Locales for the 'not USA' bits of the world
  gem 'rails-i18n'

  # Enable ShinyCMS plugins
  plugin_names.each do |plugin_name|
    gem_name = underscore( plugin_name )
    gem gem_name, path: "plugins/#{plugin_name}"
  end

  # Reduce boot times through caching; required in config/boot.rb
  gem 'bootsnap', '>= 1.4.2', require: false
  # Use faster SCSS gem for stylesheets
  gem 'sassc-rails'
  # Transpile app-like JavaScript. More info: https://github.com/rails/webpacker
  gem 'webpacker', '~> 5.2'

  # User authentication
  gem 'devise'
  # Sessions
  # FIXME: temporarily installing from GitHub to pick up an unreleased fix for Ruby 3.0.0
  # gem 'activerecord-session_store'
  gem 'activerecord-session_store', git: 'https://github.com/rails/activerecord-session_store'
  # Stronger password encryption
  gem 'bcrypt', '~> 3.1.16'
  # Check user passwords against known data leaks
  gem 'devise-pwned_password'
  # Authorisation
  gem 'pundit'

  # Soft delete
  gem 'acts_as_paranoid'

  # We use Sidekiq as the backend for ActiveJob (to queue email sends)
  gem 'sidekiq'
  # This adds more details to the Sidekiq web dashboard
  gem 'sidekiq-status'

  # Bot detection to protect forms (including registration, comments, etc)
  gem 'recaptcha'

  # Spam comment detection
  gem 'akismet'

  # Validate email addresses
  gem 'email_address'

  # Email preview
  gem 'rails_email_preview'

  # MJML emails
  gem 'mjml-rails'

  # Sortable lists (elements of template, etc)
  gem 'acts_as_list'

  # Tags
  gem 'acts-as-taggable-on'

  # Likes
  gem 'acts_as_votable'

  # Pagination
  gem 'pagy'

  # Generate Atom feeds
  gem 'rss'

  # CKEditor: WYSIWYG editor for admin area
  gem 'ckeditor'

  # Email stats
  gem 'ahoy_email'
  # Web stats
  gem 'ahoy_matey'
  # Charts and dashboards
  gem 'blazer', '2.3.1'  # https://github.com/ankane/blazer/issues/315
  # Charts
  gem 'chartkick', '~> 3.4.2'
  # Date ranges
  gem 'groupdate'

  # Image storage on S3
  gem 'aws-sdk-s3'
  # Image processing, for resizing etc
  gem 'image_processing', '~> 1.12'
  # Also image processing
  gem 'mini_magick'

  # HTML & XML parser
  gem 'nokogiri', '>= 1.11.0.rc4'

  # Better-looking console output
  gem 'amazing_print'

  # Pry is a debugging tool for the Rails console
  # Uncomment the first line if you want to use it in production, the second otherwise
  gem 'pry-rails', groups: %i[ development test production ]
  # gem 'pry-rails', groups: %i[ development test ]

  group :production do
    # Bugsnag is an error monitoring service
    gem 'bugsnag'

    # Fix request.ip if we're running behind Cloudflare's proxying service
    gem 'cloudflare-rails'
  end

  group :development, :test do
    # Tests are good, m'kay?
    gem 'rspec-rails'

    # Create test objects
    gem 'factory_bot_rails'
    # Fill test objects with fake data
    gem 'faker'

    # Utils for working with translation strings
    # gem 'i18n-debug'
    gem 'i18n-tasks', '~> 0.9.33'
  end

  group :development do
    # Linter
    gem 'rubocop', require: false
    # Rails-specific linting
    gem 'rubocop-rails', require: false
    # Tests need linting-love too!
    gem 'rubocop-rspec', require: false
    # Performance-related analysis
    gem 'rubocop-performance', require: false

    # Scan for security vulnerabilities
    gem 'brakeman', require: false
    # Check gems for security issues
    gem 'bundler-audit', require: false
    # Check for slow code
    gem 'fasterer', require: false

    # Best practices
    gem 'rails_best_practices'

    # Ruby Critic generates easy-to-read reports from various static analysis tools
    # FIXME: install this manually (gem install rubycritic) until reek is ruby3 compatible
    # gem 'rubycritic', '~> 4.5.0', require: false

    # Capture all emails sent by the system, and view them in a dev webmail inbox
    gem 'letter_opener_web', '~> 1.0'

    # Reload dev server when files change
    gem 'listen', '>= 3.0.5', '< 3.5'

    # Helps you manage your git hooks
    gem 'overcommit', require: false

    # Analysis tools for postgres
    gem 'rails-pg-extras'

    # Used to generate demo site data
    gem 'seed_dump'
  end

  group :test do
    # Wipe the test database before each test run
    gem 'database_cleaner-active_record'

    # Integration tests (request specs)
    gem 'capybara', '>= 2.15'

    # Intercept calls to external services (notably, the Algolia API)
    gem 'webmock'

    # Analyse and report on test coverage via CodeCov
    gem 'codecov', require: false
    # Rspec report formatter for Codecov
    gem 'rspec_junit_formatter'
  end
end
