# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

$LOAD_PATH.push File.expand_path( 'lib', __dir__ )

# Maintain your gem's version:
require 'shinycms/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'shinycms'
  spec.version     = ShinyCMS::VERSION
  spec.license     = 'GPL'

  spec.authors     = [ 'Denny de la Haye' ]
  spec.email       = [ '2021@denny.me' ]
  spec.homepage    = 'https://shinycms.org'

  spec.summary     = 'ShinyCMS'
  spec.description = 'This plugin provides core ShinyCMS features, and common functionality for other ShinyCMS plugins'

  spec.required_ruby_version = '~> 3.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  unless spec.respond_to? :metadata
    raise StandardError, 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.metadata[ 'allowed_push_host' ] = 'TODO: Set to http://rubygems.org when ready'

  spec.files = Dir[ '{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md' ]

  # 6.1.2.1 fixes CVE-2021-22880
  spec.add_dependency 'rails', '~> 6.1.2', '>= 6.1.2.1'

  spec.add_dependency 'pg', '~> 1.2.3'

  # Immutable data structures
  spec.add_dependency 'persistent-dmnd'

  # Sessions
  spec.add_dependency 'activerecord-session_store'

  # Stronger password encryption
  spec.add_dependency 'bcrypt', '~> 3.1.16'

  # Authentication
  spec.add_dependency 'devise'
  # Authorisation
  spec.add_dependency 'pundit'

  # Check user passwords against known data leaks
  spec.add_dependency 'devise-pwned_password'
  # Check password complexity
  spec.add_dependency 'zxcvbn-ruby'

  # Locales for the 'not USA' bits of the world
  spec.add_dependency 'rails-i18n'

  # View components
  spec.add_dependency 'view_component'

  # We use Sidekiq as the backend for ActiveJob (to queue email sends)
  spec.add_dependency 'sidekiq'
  spec.add_dependency 'sidekiq-status'

  # Soft delete
  spec.add_dependency 'acts_as_paranoid'
  # Sortable lists
  spec.add_dependency 'acts_as_list'
  # Tags
  spec.add_dependency 'acts-as-taggable-on'
  # Upvotes (AKA 'Likes') and downvotes
  spec.add_dependency 'acts_as_votable'

  # WYSIWYG editor
  spec.add_dependency 'ckeditor'

  # Pagination
  spec.add_dependency 'pagy', '~> 4.3.0'

  # Atom feeds
  spec.add_dependency 'rss'

  # Image storage on S3
  spec.add_dependency 'aws-sdk-s3'
  # Image processing (resizing, etc)
  spec.add_dependency 'image_processing', '~> 1.12'
  spec.add_dependency 'mini_magick'

  # Spambot protection
  spec.add_dependency 'akismet'
  spec.add_dependency 'recaptcha'

  # Email address validation
  spec.add_dependency 'email_address'

  # MJML email rendering
  spec.add_dependency 'mjml-rails'

  # Faster SCSS gem for stylesheets
  spec.add_dependency 'sassc-rails'

  # JavaScript and endless config frustration
  spec.add_dependency 'webpacker', '~> 5.2'

  # Improvements for the Rails console
  spec.add_dependency 'amazing_print'
  spec.add_dependency 'pry-rails'

  # HTML & XML parser (indirect dependency) - 1.10.4 fixes CVE-2019-5477
  spec.add_dependency 'nokogiri', '>= 1.10.4'

  ## Monitoring services
  spec.add_dependency 'airbrake'
  spec.add_dependency 'bugsnag'
  spec.add_dependency 'sentry-rails'
  spec.add_dependency 'sentry-ruby'

  # Fix request.ip when running behind Cloudflare proxying
  spec.add_dependency 'cloudflare-rails'

  # Used to export demo site data from the database
  spec.add_dependency 'seed_dump'

  # Test coverage; 0.20.0 is the latest version currently compatible with CodeCov and Ruby Critic
  spec.add_development_dependency 'simplecov', '~> 0.20.0'
end
