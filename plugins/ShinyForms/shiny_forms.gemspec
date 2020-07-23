# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'shiny_forms/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'shiny_forms'
  spec.version     = ShinyForms::VERSION
  spec.authors     = ['Denny de la Haye']
  spec.email       = ['2020@denny.me']
  spec.homepage    = 'https://shinycms.com'
  spec.summary     = 'Forms for ShinyCMS.'
  spec.description = 'Forms plugin for ShinyCMS.'
  spec.license     = 'GPL 2.0+'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://rubygems.org' in some notional future"
  else
    raise StandardError, 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '~> 6.0.3', '>= 6.0.3.2'

  spec.add_dependency 'pg', '>= 0.18', '< 2.0'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
end
