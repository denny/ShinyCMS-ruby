# frozen_string_literal: true

module ShinyNews
  # Load the engine that powers the plugin
  class Engine < ::Rails::Engine
    isolate_namespace ShinyNews

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    initializer 'shiny_news.factories', after: 'factory_bot.set_factory_paths' do
      plugin_factories = File.expand_path( '../../spec/factories', __dir__ )
      FactoryBot.definition_file_paths << plugin_factories if defined? FactoryBot
    end
  end
end
