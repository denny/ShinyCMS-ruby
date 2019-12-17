source 'https://rubygems.org' do
  gem 'rails', '~> 6.0.0'

  gem 'pg', '>= 0.18', '< 2.0'

  gem 'puma', '~> 4.3'

  # Use Active Model has_secure_password
  gem 'bcrypt', '~> 3.1.7'

  # Reduces boot times through caching; required in config/boot.rb
  gem 'bootsnap', '>= 1.4.2', require: false
  # Use faster SCSS gem for stylesheets
  gem 'sassc-rails'
  # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
  gem 'webpacker', '~> 4.2'

  # Sessions, authentication, and authorisation
  gem 'activerecord-session_store'
  gem 'devise'
  gem 'devise-pwned_password'
  gem 'pundit'

  # Utils for working with translation strings
  gem 'i18n-tasks', '~> 0.9.29'

  # CKEditor: WYSIWYG editor for admin area
  gem 'ckeditor'

  # Image storage on S3, image processing (resizing)
  gem 'aws-sdk-s3'
  gem 'image_processing', '~> 1.2'
  gem 'mini_magick'

  # Pagination
  gem 'kaminari'

  group :development, :test do
    gem 'awesome_print'
    gem 'bundler-audit', require: false
    gem 'factory_bot_rails'
    gem 'faker'
    gem 'pry-rails'
    gem 'rspec-rails'
    gem 'rubocop'
    gem 'rubocop-rails'
  end

  group :development do
    # Used to create demo site data
    gem 'db_fixtures_dump'
    # Reload dev server when files change
    gem 'listen', '>= 3.0.5', '< 3.3'
  end

  group :test do
    # Integration tests (request specs)
    gem 'capybara', '>= 2.15'
    # Analyse and report on test coverage via CodeCov.io
    gem 'codecov', require: false
    gem 'rspec_junit_formatter'
  end
end
