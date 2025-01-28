# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path( '../Gemfile', __dir__ )

# Set up gems listed in the Gemfile
require 'bundler/setup'

# Fix/ignore concurrent-ruby upgrade issue: https://stackoverflow.com/a/79361190
# This should be safe to remove in Rails 7.1
require 'logger'

# Load bootsnap here if you're using it
# require 'bootsnap/setup'
