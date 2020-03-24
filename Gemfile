source 'https://rubygems.org' do
  gem 'rails', '~> 6.0.2'

  gem 'pg', '>= 0.18', '< 2.0'

  gem 'puma', '~> 4.3'

  # Load ENV from .env(.*) files
  gem 'dotenv-rails'

  # Reduce boot times through caching; required in config/boot.rb
  gem 'bootsnap', '>= 1.4.2', require: false
  # Use faster SCSS gem for stylesheets
  gem 'sassc-rails'
  # Transpile app-like JavaScript. More info: https://github.com/rails/webpacker
  gem 'webpacker', '~> 5.0'

  # Sessions, authentication, and authorisation
  gem 'activerecord-session_store'
  gem 'bcrypt', '~> 3.1.7'
  gem 'devise'
  gem 'devise-pwned_password'
  gem 'pundit'

  # Bot detection to protect forms (including registration, comments, etc)
  gem 'recaptcha'

  # Spam comment detection
  gem 'akismet'

  # Validate email addresses
  gem 'email_address'

  # MJML emails
  gem 'mjml-rails'

  # Tags
  gem 'acts-as-taggable-on'

  # Pagination
  gem 'kaminari'

  # CKEditor: WYSIWYG editor for admin area
  gem 'ckeditor'

  # Web stats
  gem 'ahoy_matey'

  # Image storage on S3, image processing (resizing)
  gem 'aws-sdk-s3'
  gem 'image_processing', '~> 1.10'
  gem 'mini_magick'

  # Better-looking console output
  gem 'awesome_print'

  # Pry is a debugging tool
  # Uncomment it here if you want to use it on the Rails console in production
  gem 'pry-rails'

  group :development, :test do
    # Debugging tool. Uncomment it here if you commented it out in production.
    # gem 'pry-rails'
    # Create test objects
    gem 'factory_bot_rails'
    # Fill test objects with fake data
    gem 'faker'
    # Utils for working with translation strings
    gem 'i18n-tasks', '~> 0.9.31'
    # Tests are good, m'kay?
    gem 'rspec-rails'
  end

  group :development do
    # Scan for security vulnerabilities
    gem 'brakeman', require: false
    # Check gems for security issues
    gem 'bundler-audit', require: false
    # Used to create demo site data
    gem 'db_fixtures_dump'
    # Check for slow code
    gem 'fasterer', require: false
    # Open emails sent by the system in a browser tab
    gem 'letter_opener'
    # Reload dev server when files change
    gem 'listen', '>= 3.0.5', '< 3.3'
    # Helps you manage your git hooks
    gem 'overcommit', require: false
    # Linter
    gem 'rubocop', require: false
    gem 'rubocop-rails', require: false
  end

  group :test do
    # Integration tests (request specs)
    gem 'capybara', '>= 2.15'
    # Wipe the test database before each test run
    gem 'database_cleaner-active_record'
    # Analyse and report on test coverage via CodeCov
    gem 'codecov', require: false
    gem 'rspec_junit_formatter'
  end
end
