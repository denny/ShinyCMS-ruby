# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

$LOAD_PATH.push File.expand_path( 'lib', __dir__ )

# Maintain your gem's version:
require 'shiny_news/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'shiny_news'
  spec.version     = ShinyNews::VERSION
  spec.authors     = [ 'Denny de la Haye' ]
  spec.email       = [ '2020@shinycms.org' ]
  spec.homepage    = 'https://shinycms.org'
  spec.summary     = 'ShinyNews plugin for ShinyCMS'
  spec.description = 'The ShinyNews plugin provides a news section for ShinyCMS'
  spec.license     = 'GPL'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  unless spec.respond_to?( :metadata )
    raise StandardError, 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.metadata['allowed_push_host'] = 'TODO: Set to http://rubygems.org in some notional future'

  spec.files = Dir[ '{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md' ]

  spec.add_dependency 'rails', '~> 6.0.3', '>= 6.0.3.4'

  spec.add_dependency 'pg', '>= 0.18', '< 2.0'

  # Authorisation
  spec.add_dependency 'pundit'

  # Soft delete
  spec.add_dependency 'acts_as_paranoid'

  # Tags
  spec.add_dependency 'acts-as-taggable-on'

  # Pagination
  spec.add_dependency 'kaminari'

  # CKEditor: WYSIWYG editor for admin area
  spec.add_dependency 'ckeditor'

  # Testing
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'rspec-rails'
end
