# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'shinycms/engine'

# Immutable data structures (used in Plugins code)
require 'persistent-dmnd'

# Low level authentication-related stuff
require 'activerecord/session_store'
require 'bcrypt'

# High-level authentication and authorisation stuff
require 'devise'
require 'devise/pwned_password'
require 'pundit'
require 'zxcvbn'

# View components
require 'view_component'

# Job queues
require 'sidekiq'
require 'sidekiq-status'

# Extend behaviour, mostly of models
require 'acts-as-taggable-on'
require 'acts_as_list'
require 'acts_as_paranoid'
require 'acts_as_votable'

# Pagination
require 'pagy'

# Generate Atom feeds
require 'rss'

# Image storage on S3
require 'aws-sdk-s3'
# Image processing (resizing, etc)
require 'image_processing'
require 'mini_magick'

# Spambot protection
require 'akismet'
require 'recaptcha'

# Email address validation
require 'email_address'

# MJML email rendering
require 'mjml-rails'

# Improvements for the Rails console
if Rails.env.local? || ENV.fetch( 'SHINYCMS_PRY_CONSOLE', 'false' ).downcase == 'true'
  require 'amazing_print'
  require 'pry-rails'
end

# Restore original request.ip when behind Cloudflare proxying
require 'cloudflare_rails'

# Monitoring services
require 'airbrake'     if ENV[ 'AIRBRAKE_API_KEY' ].present?
require 'bugsnag'      if ENV[ 'BUGSNAG_API_KEY'  ].present?
require 'scout_apm'    if ENV[ 'SCOUT_KEY'        ].present?
require 'sentry-rails' if ENV[ 'SENTRY_DSN'       ].present?
require 'sentry-ruby'  if ENV[ 'SENTRY_DSN'       ].present?

# Top-level namespace wrapper
module ShinyCMS
  mattr_reader :config_user_model

  def self.configure( user_model: nil )
    # rubocop:disable Style/ClassVars
    @@config_user_model = user_model if user_model
    # rubocop:enable Style/ClassVars
  end

  # Default config
  configure( user_model: 'ShinyCMS::User' )

  # Build the configured plugin collection, and stash it in ShinyCMS.plugins for easy re-use
  def self.plugins
    @plugins ||= ShinyCMS::Plugins.all
  end

  # Force a rebuild of the plugin collection
  def self.reload_plugins
    @plugins = ShinyCMS::Plugins.all
  end
end
