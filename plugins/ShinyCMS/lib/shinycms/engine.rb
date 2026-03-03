# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Loads Rails::Engine features
  class Engine < ::Rails::Engine
    isolate_namespace ShinyCMS

    config.paths.add 'app/components',                  eager_load: true
    config.paths.add 'app/public/components',           eager_load: true
    config.paths.add 'app/public/components/concerns',  eager_load: true
    config.paths.add 'app/public/controllers',          eager_load: true
    config.paths.add 'app/public/controllers/concerns', eager_load: true
    config.paths.add 'app/public/lib',                  eager_load: true
    config.paths.add 'app/public/helpers',              eager_load: true
    config.paths.add 'app/public/mailers',              eager_load: true
    config.paths.add 'app/public/models',               eager_load: true
    config.paths.add 'app/public/models/concerns',      eager_load: true
    config.paths.add 'app/public/services',             eager_load: true

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    initializer 'shinycms.factories', after: 'factory_bot.set_factory_paths' do
      plugin_factories = File.expand_path( '../../spec/factories', __dir__ )
      FactoryBot.definition_file_paths << plugin_factories if defined? FactoryBot
    end
  end
end
