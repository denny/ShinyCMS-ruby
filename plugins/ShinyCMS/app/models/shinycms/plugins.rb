# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
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

    # If no plugins or plugin names are passed to .get then it defaults to
    # building a collection of all feature plugins (excludes the core plugin)
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

    def self.feature_plugin_names
      return @feature_plugin_names if defined? @feature_plugin_names

      configured = ENV.fetch( 'SHINYCMS_PLUGINS', '' ).split( /[, ]+/ ).collect( &:to_sym )
      on_disk    = Dir[ 'plugins/*' ].collect { |name| name.sub( 'plugins/', '' ).to_sym }

      @feature_plugin_names = 💎ify[ configured.intersection( on_disk ) - [ :ShinyCMS ] ]
    end

    # More syntactic sugar
    class << self
      delegate :with_main_site_helpers, to: :all
      delegate :with_models,            to: :all
      delegate :with_views,             to: :all
      delegate :with_partial,           to: :all

      delegate :loaded?,                to: :all
      delegate :include?,               to: :all
    end

    private

    attr_reader :plugins

    def build_plugins( new_plugins )
      return 💎ify[ new_plugins ] if new_plugins.all? ShinyCMS::Plugin

      built = build_plugins_from_names( new_plugins )
      return built if built.present?

      raise ArgumentError, "Required: valid plugin names, or ShinyCMS::Plugin objects. Received: #{new_plugins}"
    end

    def build_plugins_from_names( requested_names )
      names_as_symbols = coerce_to_symbols( requested_names )
      names_that_exist = check_against_filenames( names_as_symbols )

      💎ify[ names_that_exist.collect { |name| ShinyCMS::Plugin.get( name ) } ]
    end

    def coerce_to_symbols( requested_names )
      requested_names.collect( &:to_s ).collect( &:to_sym )
    end

    def check_against_filenames( requested_names )
      # We need .to_a here because a💎 doesn't have .intersection (or &)
      requested_names.to_a.intersection( Plugins.feature_plugin_names )
    end
  end
end
