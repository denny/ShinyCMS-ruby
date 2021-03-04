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

# Extend model behaviour (mostly)
require 'acts_as_paranoid'
require 'acts_as_list'
require 'acts-as-taggable-on'
require 'acts_as_votable'

# Pagination
require 'pagy'

# Generate Atom feeds
require 'rss'

# Spambot protection
require 'akismet'
require 'recaptcha'

# Email address validation
require 'email_address'

# MJML email rendering
require 'mjml-rails'

# JavaScript Gank
require 'webpacker'

# Namespace wrapper
module ShinyCMS
  # Build the full plugin collection and stash it in the top-level module for re-use
  def self.plugins
    @plugins ||= ShinyCMS::Plugins.all
  end
end
