# frozen_string_literal: true

$LOAD_PATH.push File.expand_path( 'lib', __dir__ )

# Maintain your gem's version:
require 'shiny_blogs/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'shiny_blogs'
  spec.version     = ShinyBlogs::VERSION
  spec.license     = 'GPL'

  spec.authors     = [ 'Denny de la Haye' ]
  spec.email       = [ '2020@denny.me' ]
  spec.homepage    = 'https://shinycms.org'

  spec.summary     = 'ShinyBlogs plugin for ShinyCMS'
  spec.description = 'The ShinyBlogs plugin allows ShinyCMS to host multiple blogs on one site'

  spec.required_ruby_version = '~> 3.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  unless spec.respond_to? :metadata
    raise StandardError, 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.metadata[ 'allowed_push_host' ] = 'TODO: Set to http://rubygems.org when ready'

  spec.files = Dir[ '{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md' ]

  spec.add_dependency 'rails', '~> 6.1.0'

  spec.add_dependency 'pg', '~> 1.2.3'

  # Authorisation
  spec.add_dependency 'pundit'

  # Soft delete
  spec.add_dependency 'acts_as_paranoid'

  # Tags
  spec.add_dependency 'acts-as-taggable-on'

  # Pagination
  spec.add_dependency 'pagy'

  # CKEditor: WYSIWYG editor for admin area
  spec.add_dependency 'ckeditor'

  # Testing
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'rspec-rails'
end
