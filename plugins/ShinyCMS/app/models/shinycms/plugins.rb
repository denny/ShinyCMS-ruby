# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Interface to the ShinyCMS plugins
  class Plugins
    include Persistent💎

    include PluginsSugar

    def initialize( plugins = nil )
      plugins = build_plugins( plugins ) if plugins&.to_a&.all? String

      unless plugins.nil? || plugins.to_a.all?( ShinyCMS::Plugin )
        raise ArgumentError, 'You must pass in Plugin objects or plugin names'
      end

      @_plugins = plugins || all_feature_plugins
    end

    # Instance methods

    delegate :include?, to: :names

    delegate :collect, to: :_plugins
    delegate :each,    to: :_plugins
    delegate :to_a,    to: :_plugins

    def names
      💎ify[ _plugins.collect( &:name ) ].to_a
    end

    def add( plugin_name )
      return self if _plugins.include? plugin_name

      Plugins.new( _plugins.add( build_plugin( plugin_name ) ) )
    end

    def remove( plugin_name )
      return self unless include? plugin_name

      # TODO: find plugin by name instead of wastefully instantiating
      Plugins.new( _plugins.delete( build_plugin( plugin_name ) ) )
    end

    def with_main_site_helpers
      Plugins.new( _plugins.select { |plugin| plugin.respond_to? :main_site_helper }.to_a )
    end

    def with_models
      Plugins.new( _plugins.select { |plugin| plugin.respond_to? :base_model }.to_a )
    end

    def with_views
      Plugins.new( a💎[ _plugins.select( &:view_path ) ] )
    end

    def with_template( template_path )
      Plugins.new( with_views.select { |plugin| plugin.template_exists?( template_path ) } )
    end

    def all_routes
      💎ify[ _plugins.collect( &:routes ) ].to_a
    end

    def models_that_are( method )
      💎ify[ with_models.collect { |plugin| plugin.models_that_are method }.flatten.sort_by( &:name ) ].to_a
    end

    def models_that_respond_to( method )
      💎ify[ with_models.collect { |plugin| plugin.models_that_respond_to method }.flatten.sort_by( &:name ) ].to_a
    end

    private

    attr_reader :_plugins

    def core_plugin
      Plugin.new( 'ShinyCMS' )
    end

    def all_feature_plugins
      build_plugins( all_feature_plugin_names )
    end

    def build_plugins( plugins )
      return plugins if plugins.all? { |plugin| plugin.is_a? ShinyCMS::Plugin }

      💎ify[ plugins&.collect { |plugin| build_plugin( plugin ) } ]
    end

    def build_plugin( plugin )
      return plugin if plugin.is_a? ShinyCMS::Plugin
      return ShinyCMS::Plugin.new( plugin ) if plugin.is_a? String

      raise ArgumentError, 'Must be a ShinyCMS::Plugin or a plugin name'
    end

    def all_feature_plugin_names
      return plugin_names_in_config_that_exist unless plugin_names_in_config_that_exist.include? 'ShinyCMS'

      plugin_names_in_config_that_exist.delete( 'ShinyCMS' )
    end

    def plugin_names_in_config_that_exist
      plugin_names_in_config.select { |name| plugin_exists?( name ) }
    end

    def plugin_names_in_config
      names = ENV.fetch( 'SHINYCMS_PLUGINS', '' ).split( /[, ]+/ ).uniq.presence
      @plugin_names_in_config = 💎ify[ names ] if names
    end

    def plugin_exists?( name )
      plugin_names_on_disk.include?( name )
    end

    def plugin_names_on_disk
      💎ify[ Dir[ 'plugins/*' ].collect { |name| name.sub( 'plugins/', '' ) } ]
    end
  end
end
