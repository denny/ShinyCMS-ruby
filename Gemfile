# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Supporting methods for loading ShinyCMS plugin gems
def available_plugins
  Dir[ 'plugins/*' ].sort.collect { |name| name.sub( 'plugins/', '' ) }
end

def plugin_names
  requested = ENV[ 'SHINYCMS_PLUGINS' ]&.split( /[, ]+/ )

  return requested.uniq.select { |name| available_plugins.include?( name ) } if requested

  available_plugins
end

def underscore( camel_cased_word )
  word = camel_cased_word.to_s
  word = word.gsub( /([A-Z\d]+)([A-Z][a-z])/, '\1_\2' )
  word = word.gsub( /([a-z\d])([A-Z])/, '\1_\2' )
  word = word.tr( '-', '_' )
  word.downcase
end

# The actual Gemfile!
source 'https://rubygems.org' do
  # Rails 6.1
  gem 'rails', '~> 6.1.0'

  # Postgres
  gem 'pg', '~> 1.2.3'

  # Webserver
  gem 'puma', '~> 5.1'

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
  gem 'activerecord-session_store'
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
  # Pagination
  gem 'kaminari'
  # Allow passing route helpers (for Rails engines) into pagination blocks
  gem 'kaminari_route_prefix'

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

  # Better-looking console output
  gem 'amazing_print'

  # Pry is a debugging tool - uncomment it here if you want to use it on the Rails console in production
  gem 'pry-rails'

  group :production do
    if ENV[ 'BUGSNAG_API_KEY' ]
      # Bugsnag is an error monitoring service
      gem 'bugsnag'
    end

    # Fix request.ip if we're running behind Cloudflare's proxying service
    gem 'cloudflare-rails'
  end

  group :development, :test do
    # You can enable Pry here if you commented it out in production.
    # gem 'pry-rails'

    # Tests are good, m'kay?
    gem 'rspec-rails'

    # Create test objects
    gem 'factory_bot_rails'
    # Fill test objects with fake data
    gem 'faker'

    # Best practices
    gem 'rails_best_practices'

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

    # Capture all emails sent by the system, and view them in a dev webmail inbox
    gem 'letter_opener_web', '~> 1.0'

    # Reload dev server when files change
    gem 'listen', '>= 3.0.5', '< 3.4'

    # Helps you manage your git hooks
    gem 'overcommit', require: false

    # Analysis tools for postgres
    gem 'rails-pg-extras'

    # Used to generate demo site data
    gem 'seed_dump'
  end

  group :test do
    # Integration tests (request specs)
    gem 'capybara', '>= 2.15'
    # Wipe the test database before each test run
    gem 'database_cleaner-active_record'

    # Analyse and report on test coverage via CodeCov
    gem 'codecov', require: false
    # Rspec report formatter for Codecov
    gem 'rspec_junit_formatter'

    # Used to intercept calls to the Algolia API
    gem 'webmock'
  end
end
