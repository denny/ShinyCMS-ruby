source 'https://rubygems.org' do
  gem 'rails', '~> 6.0.2'

  gem 'pg', '>= 0.18', '< 2.0'

  gem 'puma', '~> 4.3'

  # Use Active Model has_secure_password
  gem 'bcrypt', '~> 3.1.7'

  # Reduce boot times through caching; required in config/boot.rb
  gem 'bootsnap', '>= 1.4.2', require: false
  # Use faster SCSS gem for stylesheets
  gem 'sassc-rails'
  # Transpile app-like JavaScript. More info: https://github.com/rails/webpacker
  gem 'webpacker', '~> 4.2'

  # Sessions, authentication, and authorisation
  gem 'activerecord-session_store'
  gem 'devise'
  gem 'devise-pwned_password'
  gem 'pundit'

  # Bot detection to protect forms (including registration, comments, etc)
  gem 'recaptcha'

  # Pagination
  gem 'kaminari'

  # Tags
  gem 'acts-as-taggable-on'

  # Image storage on S3, image processing (resizing)
  gem 'aws-sdk-s3'
  gem 'image_processing', '~> 1.10'
  gem 'mini_magick'

  # CKEditor: WYSIWYG editor for admin area
  gem 'ckeditor'

  # Validate email addresses
  gem 'email_address'

  # MJML emails
  gem 'mjml-rails'

  group :development, :test do
    # Better-looking console output
    gem 'awesome_print'
    # Check gems for security issues
    gem 'bundler-audit', require: false
    # Create test objects
    gem 'factory_bot_rails'
    # Fill test objects with fake data
    gem 'faker'
    # Utils for working with translation strings
    gem 'i18n-tasks', '~> 0.9.30'
    # Debugging tool
    gem 'pry-rails'
    # Tests are good, m'kay?
    gem 'rspec-rails'
    # Linter
    gem 'rubocop'
    gem 'rubocop-rails'
  end

  group :development do
    # Used to create demo site data
    gem 'db_fixtures_dump'
    # Open emails sent by the system in a browser tab
    gem 'letter_opener'
    # Reload dev server when files change
    gem 'listen', '>= 3.0.5', '< 3.3'
  end

  group :test do
    # Integration tests (request specs)
    gem 'capybara', '>= 2.15'
    # Analyse and report on test coverage via CodeCov
    gem 'codecov', require: false
    gem 'rspec_junit_formatter'
  end
end
