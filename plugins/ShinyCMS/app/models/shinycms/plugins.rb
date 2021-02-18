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
    def initialize( plugins = nil )
      @_plugins = build_plugins( plugins || all_feature_plugin_names )
    end

    delegate :include?, to: :names

    delegate :collect,  to: :_plugins
    delegate :select,   to: :_plugins
    delegate :reject,   to: :_plugins
    delegate :each,     to: :_plugins
    delegate :to_a,     to: :_plugins

    def names
      💎ify[ _plugins.collect( &:name ) ]
    end

    def include?( plugin_name )
      names.include? plugin_name.to_s
    end

    # These aren't used currently
    # def add( plugin_name )
    #  return self if _plugins.include? plugin_name

    #  Plugins.new( _plugins.add( build_plugin( plugin_name ) ) )
    # end

    # def remove( plugin_name )
    #  return self unless include? plugin_name

    #  Plugins.new( _plugins.reject { |plugin| plugin.name == plugin_name } )
    # end

    def with_main_site_helpers
      Plugins.new( _plugins.select( &:main_site_helper ) )
    end

    def with_models
      Plugins.new( _plugins.select( &:base_model ) )
    end

    def with_views
      Plugins.new( _plugins.select( &:view_path ) )
    end

    def with_template( template_path )
      Plugins.new( with_views.select { |plugin| plugin.template_exists?( template_path ) } ).to_a
    end

    def all_routes
      💎ify[ _plugins.collect( &:routes ).flatten ]
    end

    def models_that_are( method )
      💎ify[ with_models.collect { |plugin| plugin.models_that_are method }.flatten.sort_by( &:name ) ]
    end

    def models_that_respond_to( method )
      💎ify[ with_models.collect { |plugin| plugin.models_that_respond_to method }.flatten.sort_by( &:name ) ]
    end

    def self.available_plugin_names
      @available_plugin_names ||= 💎ify[ Dir[ 'plugins/*' ].collect { |name| name.sub( 'plugins/', '' ) } ]
    end

    private

    attr_reader :_plugins

    def build_plugins( plugins )
      plugins = a💎[ plugins ].flatten

      return plugins if plugins.all? ShinyCMS::Plugin

      💎ify[ plugins.collect { |plugin| build_plugin( plugin ) } ]
    end

    def build_plugin( plugin )
      return plugin if plugin.is_a? ShinyCMS::Plugin
      return ShinyCMS::Plugin.new( plugin ) if all_plugin_names.include?( plugin.to_s )

      raise ArgumentError, 'Must be the name of a ShinyCMS plugin which is in the plugins directory'
    end

    def all_feature_plugin_names
      return all_plugin_names unless all_plugin_names.include? 'ShinyCMS'

      all_plugin_names.delete( 'ShinyCMS' )
    end

    def all_plugin_names
      @all_plugin_names ||= configured_plugin_names.select { |name| self.class.available_plugin_names.include?( name ) }
    end

    def configured_plugin_names
      💎ify[ ENV.fetch( 'SHINYCMS_PLUGINS', '' ).split( /[, ]+/ ).uniq ]
    end
  end
end
