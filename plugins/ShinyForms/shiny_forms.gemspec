# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

$LOAD_PATH.push File.expand_path( 'lib', __dir__ )

# Maintain your gem's version:
require 'shiny_forms/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'shiny_forms'
  spec.version     = ShinyForms::VERSION
  spec.license     = 'GPL'

  spec.authors     = [ 'Denny de la Haye' ]
  spec.email       = [ '2025@denny.me' ]
  spec.homepage    = 'https://shinycms.org'

  spec.summary     = 'ShinyForms plugin for ShinyCMS'
  spec.description = 'The ShinyForms plugin provides some generic form handlers for ShinyCMS'

  spec.required_ruby_version = '>= 3.4'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  unless spec.respond_to?( :metadata )
    raise StandardError, 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://rubygems.org' in some notional future"

  spec.files = Dir[ '{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md' ]

  spec.add_dependency 'rails', '>= 8.0.2', '< 8.1'

  spec.add_dependency 'pg', '>= 1.2.3', '< 1.6.0'

  # Authorisation
  spec.add_dependency 'pundit'

  # Soft delete
  spec.add_dependency 'acts_as_paranoid'

  # Pagination
  spec.add_dependency 'pagy', '~> 9.3.4'

  # HTML & XML parser
  spec.add_dependency 'nokogiri', '>= 1.18.8'

  # Testing
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'rspec-rails'
end
