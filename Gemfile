# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Supporting methods for loading ShinyCMS plugin gems
def plugin_names
  return ENV[ 'SHINYCMS_PLUGINS' ].split( /[, ]+/ ) if ENV[ 'SHINYCMS_PLUGINS' ]

  Dir[ 'plugins/*' ].sort.collect { |plugin_name| plugin_name.sub( 'plugins/', '' ) }
end

def underscore( camel_cased_word )
  word = camel_cased_word.to_s
  word = word.gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
  word = word.gsub(/([a-z\d])([A-Z])/, '\1_\2')
  word = word.tr('-', '_')
  word.downcase
end

# The actual Gemfile!
source 'https://rubygems.org' do
  gem 'rails', '~> 6.0.3'

  # Database
  gem 'pg', '>= 0.18', '< 2.0'

  # Webserver
  gem 'puma', '~> 4.3'

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

  # Sessions, authentication, and authorisation
  gem 'activerecord-session_store'
  gem 'bcrypt', '~> 3.1.16'
  gem 'devise'
  gem 'devise-pwned_password'
  gem 'pundit'

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

  # Search
  gem 'algoliasearch-rails'
  gem 'pg_search'

  # Sortable lists (elements of template, etc)
  gem 'acts_as_list'

  # Tags
  gem 'acts-as-taggable-on'

  # Likes
  gem 'acts_as_votable'

  # Pagination
  gem 'kaminari'

  # CKEditor: WYSIWYG editor for admin area
  gem 'ckeditor'

  # Email stats
  gem 'ahoy_email'
  # Web stats
  gem 'ahoy_matey'
  gem 'blazer'
  gem 'chartkick', '~> 3.4.0'
  gem 'groupdate'

  # Image storage on S3, image processing (resizing)
  gem 'aws-sdk-s3'
  gem 'image_processing', '~> 1.11'
  gem 'mini_magick'

  # Better-looking console output
  gem 'amazing_print'

  # Pry is a debugging tool - uncomment it here if you want to use it on the Rails console in production
  gem 'pry-rails'

  group :development, :test do
    # You can enable Pry here if you commented it out in production.
    # gem 'pry-rails'
    # Create test objects
    gem 'factory_bot_rails'
    # Fill test objects with fake data
    gem 'faker'
    # Utils for working with translation strings
    # gem 'i18n-debug'
    gem 'i18n-tasks', '~> 0.9.31'
    # Tests are good, m'kay?
    gem 'rspec-rails'
  end

  group :development do
    # Scan for security vulnerabilities
    gem 'brakeman', require: false
    # Check gems for security issues
    gem 'bundler-audit', require: false
    # Check for slow code
    gem 'fasterer', require: false
    # Capture all emails sent by the system, and view them in a dev webmail inbox
    gem 'letter_opener_web', '~> 1.0'
    # Reload dev server when files change
    gem 'listen', '>= 3.0.5', '< 3.3'
    # Helps you manage your git hooks
    gem 'overcommit', require: false
    # Linter
    gem 'rubocop', require: false
    gem 'rubocop-rails', require: false
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
    gem 'rspec_junit_formatter'
    # Used to intercept calls to the Algolia API
    gem 'webmock'
  end
end
