# frozen_string_literal: true

module ShinyForms
  # Load the engine that powers the plugin
  class Engine < ::Rails::Engine
    isolate_namespace ShinyForms

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end
  end
end
