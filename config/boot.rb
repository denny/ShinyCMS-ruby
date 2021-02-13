# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path( '../Gemfile', __dir__ )

# Set up gems listed in the Gemfile
require 'bundler/setup'

# Load bootsnap here if you're using it
# require 'bootsnap/setup'
