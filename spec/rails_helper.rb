# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Config for test suite (anything Rails-specific can go in here)

require 'spec_helper'
require 'database_cleaner'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path( '../config/environment', __dir__ )

# Prevent database truncation if the environment is production
abort 'Rails is running in production mode!' if Rails.env.production?

require 'rspec/rails'

# Add additional requires below this line; Rails is not loaded until this point

# Capybara matchers, for more readable tests
require 'capybara/rails'

# Supply random fake data to tests, to make them work a bit harder
require 'faker'

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
Dir[ Rails.root.join( 'spec/support/**/*.rb' ) ].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.before( :suite ) do
    DatabaseCleaner.clean_with :truncation

    # Load feature flags, capabilities, etc
    ShinyCMS::Application.load_tasks
    Rake::Task['db:seed'].invoke

    # These default to off for privacy, but we want to test the integration
    FeatureFlag.enable :ahoy_web_tracking
    FeatureFlag.enable :ahoy_email_tracking
  end

  config.before :each do
    WebMock.enable!
  end

  config.after :each do
    WebMock.disable!
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Load the Devise test helpers
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :helper

  # Allow request specs to use have_* matchers, like so:
  # expect( response.body ).to have_title 'My Page Title'
  config.include Capybara::RSpecMatchers, type: :request
end
