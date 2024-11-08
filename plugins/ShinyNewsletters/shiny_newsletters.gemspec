# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

$LOAD_PATH.push File.expand_path( 'lib', __dir__ )

# Maintain your gem's version:
require 'shiny_newsletters/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'shiny_newsletters'
  spec.version     = ShinyNewsletters::VERSION
  spec.license     = 'GPL'

  spec.authors     = [ 'Denny de la Haye' ]
  spec.email       = [ '2023@denny.me' ]
  spec.homepage    = 'https://shinycms.org'

  spec.summary     = 'ShinyNewsletters plugin for ShinyCMS'
  spec.description = 'The ShinyNewsletters plugin adds mailing list and newsletter features to ShinyCMS'

  spec.required_ruby_version = '>= 3.1'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  unless spec.respond_to? :metadata
    raise StandardError, 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.metadata[ 'allowed_push_host' ] = 'TODO: Set to http://rubygems.org when ready'

  spec.files = Dir[ '{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md' ]

  spec.add_dependency 'rails', '>= 6.1.2.1', '< 9'

  spec.add_dependency 'pg', '>= 1.2.3', '< 1.6.0'

  # Authorisation
  spec.add_dependency 'pundit'

  # Soft delete
  spec.add_dependency 'acts_as_paranoid'

  # Pagination
  spec.add_dependency 'pagy', '>= 5.10', '< 8.0'

  # CKEditor: WYSIWYG editor for admin area
  spec.add_dependency 'ckeditor'

  # HTML & XML parser
  spec.add_dependency 'nokogiri', '>= 1.11.0.rc4'

  # Testing
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'rspec-rails'
end
