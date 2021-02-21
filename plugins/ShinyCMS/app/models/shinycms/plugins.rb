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

      new_plugin_set = new( new_plugins || all_plugin_names )
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

    def self.all_plugin_names
      return @all_plugin_names if defined? @all_plugin_names

      on_disk   = Dir[ 'plugins/*' ].collect { |name| name.sub( 'plugins/', '' ).to_sym }
      requested = ENV.fetch( 'SHINYCMS_PLUGINS', '' ).split( /[, ]+/ ).collect( &:to_sym )

      @all_plugin_names = 💎ify[ requested.intersection( on_disk ) - [ :ShinyCMS ] ]
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

    def build_plugins_from_names( to_build )
      names = to_build.all?( String ) ? to_build.collect( &:to_sym ) : to_build
      return unless names.all?( Symbol )

      # Wouldn't need .to_a here if a💎 supported .intersection (or &)
      💎ify[ names.to_a.intersection( Plugins.all_plugin_names ).collect { |plugin| ShinyCMS::Plugin.get( plugin ) } ]
    end
  end
end
