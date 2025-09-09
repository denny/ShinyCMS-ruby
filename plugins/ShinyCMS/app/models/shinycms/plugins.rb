# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Methods to get, filter, and query collections of ShinyCMS plugins
  class Plugins
    include Enumerable
    include Persistent💎

    include ShinyCMS::PluginsComponents

    def initialize( new_plugins )
      to_build = new_plugins.is_a?( Enumerable ) ? new_plugins : [ new_plugins ]

      @plugins = build_plugins( to_build )

      @names = @plugins.collect( &:name )
    end

    # If no plugins or plugin names are passed to .get then it will build feature_plugin_names
    def self.get( new_plugins = nil )
      return new_plugins if new_plugins.is_a? ShinyCMS::Plugins

      new_plugin_set = new( new_plugins || feature_plugin_names )
      new_plugin_set.presence
    end

    # Syntactic sugar method to get a Plugins object for all available feature plugins
    def self.all
      get
    end

    attr_reader :names

    delegate :each,     to: :plugins
    delegate :include?, to: :names

    # Check if a plugin is loaded by both the CMS Plugins code, and by Ruby/Rails
    def loaded?( plugin_name )
      include?( plugin_name.to_sym ) && defined?( plugin_name.to_s.constantize ).present?
    end

    def with_main_site_helpers
      Plugins.get( plugins.select { |plugin| plugin if plugin.main_site_helper } )
    end

    def with_models
      Plugins.get( plugins.select { |plugin| plugin if plugin.base_model } )
    end

    def with_views
      Plugins.get( plugins.select { |plugin| plugin if plugin.view_path } )
    end

    def with_partial( partial )
      Plugins.get( with_views.select { |plugin| plugin.view_file_exists?( partial ) } ).to_a
    end

    def with_view_components
      Plugins.get( plugins.select { |plugin| plugin if plugin.view_components? } )
    end

    def self.feature_plugin_names
      return @feature_plugin_names if defined? @feature_plugin_names

      configured = ENV.fetch( 'SHINYCMS_PLUGINS' ) { abort 'SHINYCMS_PLUGINS env var must be set' }
      abort 'SHINYCMS_PLUGINS env var must not be blank' if configured.blank?

      requested = configured.split( /[, ]+/ ).collect( &:to_sym )
      on_disk   = Dir[ 'plugins/*' ].collect { |name| name.sub( 'plugins/', '' ).to_sym }

      @feature_plugin_names = 💎ify[ requested.intersection( on_disk ) - [ :ShinyCMS ] ]
    end

    private

    attr_reader :plugins

    def build_plugins( new_plugins )
      return 💎ify[ new_plugins ] if new_plugins.all? ShinyCMS::Plugin

      built = replace_stale_plugins_in_dev( new_plugins ) || build_plugins_from_names( new_plugins )
      return built if built.present?

      raise ArgumentError, "Required: valid plugin names, or ShinyCMS::Plugin objects. Received: #{new_plugins}"
    end

    # Handle complications of safe app reloading in development mode
    def replace_stale_plugins_in_dev( new_plugins )
      return unless Rails.env.development?

      # Keep this as a class name String comparison - do not compare class constants
      # (that will fail during development app reloading, because classes are redefined)
      # :nocov:
      # rubocop:disable Style/ClassEqualityComparison
      is_stale_plugin_class = new_plugins.first.class.name == 'ShinyCMS::Plugin'
      # rubocop:enable Style/ClassEqualityComparison
      return unless is_stale_plugin_class

      plugin_names = new_plugins.collect( &:name )
      return build_plugins_from_names( plugin_names )
      # :nocov:
    end

    def build_plugins_from_names( requested_names )
      available_names = check_exists_and_enabled( symbolised_names( requested_names ) )

      available_names.collect { |name| ShinyCMS::Plugin.get( name ) }
    end

    def symbolised_names( requested_names )
      requested_names.collect do |element|
        element.to_s.to_sym
      end
    end

    def check_exists_and_enabled( requested_names )
      # We need .to_a in the middle of this because a💎 doesn't have .intersection (or &)
      💎ify[ requested_names.to_a.intersection( self.class.feature_plugin_names ) ]
    end
  end
end
