# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Methods to fetch, filter, and query collections of ShinyCMS plugins
  class Plugins
    include Persistent💎

    include PluginsSugar

    # If no plugins or plugin names are passed to .new then it defaults to
    # building a collection of all feature plugins (excludes the core plugin)
    def initialize( new_plugins )
      @plugins = build_plugins( new_plugins )

      @names = @plugins.collect( &:name )
    end

    def self.get( new_plugins = nil )
      return new_plugins if new_plugins.is_a? ShinyCMS::Plugins

      new_plugin_set = new( new_plugins || all_plugin_names )
      new_plugin_set.presence
    end

    # Get all available plugins
    def self.all
      get
    end

    # TODO: Replace .loaded in code with .get or .all, then remove this method
    def self.loaded
      get
    end

    attr_reader :names

    delegate :collect, to: :plugins
    delegate :select,  to: :plugins
    delegate :reject,  to: :plugins
    delegate :any?,    to: :plugins
    delegate :all?,    to: :plugins
    delegate :to_a,    to: :plugins
    delegate :first,   to: :plugins
    delegate :last,    to: :plugins
    delegate :each,    to: :plugins

    delegate :each_with_index, to: :plugins  # the rspec 'all' matcher needs this

    delegate :include?, to: :names

    def loaded?( plugin_name )
      names.include?( plugin_name.to_sym ) && defined?( plugin_name.to_s.constantize ).present?
    end

    def with_main_site_helpers
      ShinyCMS::Plugins.get( plugins.select { |plugin| plugin if plugin.main_site_helper } )
    end

    def with_models
      ShinyCMS::Plugins.get( plugins.select { |plugin| plugin if plugin.base_model } )
    end

    def with_views
      ShinyCMS::Plugins.get( plugins.select { |plugin| plugin if plugin.view_path } )
    end

    def with_partial( partial )
      ShinyCMS::Plugins.get( with_views.select { |plugin| plugin.view_file_exists?( partial ) } ).to_a
    end

    def engines
      💎ify[ plugins.collect( &:engine ) ]
    end

    def routes
      💎ify[ plugins.collect( &:routes ).flatten ]
    end

    def models_that_are( method )
      💎ify[ with_models.collect { |plugin| plugin.models_that_are method }.flatten.sort_by( &:name ) ]
    end

    def models_that_respond_to( method )
      💎ify[ with_models.collect { |plugin| plugin.models_that_respond_to method }.flatten.sort_by( &:name ) ]
    end

    def self.all_plugin_names
      return @all_plugin_names if defined? @all_plugin_names

      on_disk   = Dir[ 'plugins/*' ].collect { |name| name.sub( 'plugins/', '' ).to_sym }
      requested = ENV.fetch( 'SHINYCMS_PLUGINS', '' ).split( /[, ]+/ ).collect( &:to_sym )

      @all_plugin_names = 💎ify[ requested.intersection( on_disk ) - [ :ShinyCMS ] ]
    end

    private

    attr_reader :plugins

    def build_plugins( new_plugins )
      to_build = new_plugins.respond_to?( :each ) ? new_plugins : [ new_plugins ]

      return 💎ify[ to_build ] if to_build.all? ShinyCMS::Plugin

      names = to_build.all?( String ) ? to_build.collect( &:to_sym ) : to_build

      built = 💎ify[ build_plugins_from_names( names ) ] if names.all? Symbol
      return built if built.present?

      raise ArgumentError, "Required: valid plugin names, or ShinyCMS::Plugin objects. Received: #{new_plugins}"
    end

    def build_plugins_from_names( names )
      # Wouldn't need .to_a here if a💎 supported .intersection
      names.to_a.intersection( self.class.all_plugin_names ).collect { |plugin| ShinyCMS::Plugin.get( plugin ) }
    end
  end
end
