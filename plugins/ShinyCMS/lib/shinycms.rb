# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'shinycms/engine'

# Immutable data structures (used in Plugins code)
require 'persistent-dmnd'

# Low level authentication-related stuff
require 'bcrypt'
# require 'activerecord/session_store'

# High-level authentication and authorisation stuff
require 'devise'
require 'pundit'
require 'devise/pwned_password'
require 'zxcvbn'

# Job queues
require 'sidekiq'
require 'sidekiq-status'

# Extend behaviour, mostly of models
require 'acts_as_paranoid'
require 'acts_as_list'
require 'acts-as-taggable-on'
require 'acts_as_votable'

# WYSIWYG editor
require 'ckeditor'

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

# JavaScript gank
require 'webpacker'

# Improvements for the Rails console
if Rails.env.test? || Rails.env.development? || ENV.fetch( 'SHINYCMS_PRY_CONSOLE', 'false' ).downcase == 'true'
  require 'amazing_print'
  require 'pry-rails'
end

# Restore original request.ip when behind Cloudflare proxying
require 'cloudflare/rails'

# Monitoring services
require 'airbrake' if ENV[ 'AIRBRAKE_API_KEY' ].present?
require 'bugsnag'  if ENV[ 'BUGSNAG_API_KEY'  ].present?

# Top-level namespace wrapper
module ShinyCMS
  # Build the configured plugin collection, and stash it in ShinyCMS.plugins for easy re-use
  def self.plugins
    @plugins ||= ShinyCMS::Plugins.all
  end

  # Force a rebuild of the plugin collection
  def self.reload_plugins
    @plugins = ShinyCMS::Plugins.all
  end
end
