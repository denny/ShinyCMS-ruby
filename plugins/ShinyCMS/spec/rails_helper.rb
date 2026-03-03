# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Config for test suite (anything Rails-specific can go in here)

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path( '../../../config/environment', __dir__ )

# Prevent database truncation if the environment is production
abort 'Rails is running in production mode!' if Rails.env.production?

require 'rspec/rails'

# Add additional requires below this line; Rails is not loaded until this point

# Supply random fake data to tests, to make them work a bit harder
require 'faker'

# Capybara matchers, for more readable tests
require 'capybara/rails'

# Helpers for testing View Components
require 'view_component/test_helpers'

# Mock all calls to Algolia API (their free plan has a very low transaction limit)
require 'algolia/webmock'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
Rails.root.glob( 'plugins/ShinyCMS/spec/support/**/*.rb' ).each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

send_emails = false  # set the safer default value

RSpec.configure do |config|
  config.before( :suite ) do
    DatabaseCleaner.clean_with :truncation

    # Load feature flags, capabilities, etc
    Rails.application.load_tasks
    Rake::Task['shinycms:db:seed'].invoke

    # These features default to off for privacy or security, but we want to test them
    ShinyCMS::FeatureFlag.enable :ahoy_web_tracking
    ShinyCMS::FeatureFlag.enable :ahoy_email_tracking
    ShinyCMS::FeatureFlag.enable :user_registration
    ShinyCMS::FeatureFlag.enable :user_login

    # Stash current email-sending setting
    send_emails = ShinyCMS::FeatureFlag.enabled? :send_emails

    # Turn email off during testing (override in email tests)
    ShinyCMS::FeatureFlag.disable :send_emails
  end

  config.after( :suite ) do
    # Restore original email-sending setting
    ShinyCMS::FeatureFlag.enable :send_emails if send_emails
  end

  # See spec/support/shinycms/error_responses.rb
  config.around( production_error_responses: true ) do |test|
    disable_detailed_exceptions( &test )
  end

  # Allow production-style error-handling to be selectively enabled (so it can be tested)
  config.include ShinyCMS::ErrorResponses

  # Make capybara matchers (e.g. have_title) available in component and request specs
  config.include Capybara::RSpecMatchers, type: :component
  config.include Capybara::RSpecMatchers, type: :request

  # Make devise test helper methods available in request and helper specs
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers,  type: :helper

  # Make view component test helper methods available in component specs
  config.include ViewComponent::TestHelpers, type: :component

  # Mix in different behaviours to your tests based on their file location
  # For example, add `get` and `post` methods to specs in `spec/requests`
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!
  # Arbitrary gems can also be filtered: config.filter_gems_from_backtrace( 'gem name' )

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Remove the following line (or set to false) if you're not using ActiveRecord
  # or you'd prefer not to run each of your examples within a transaction
  config.use_transactional_fixtures = true
end
