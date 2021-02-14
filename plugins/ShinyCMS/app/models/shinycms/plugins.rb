# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# TODO: ONCE TESTS ARE PASSING ... replace body of each class method in ShinyPlugin
# with a call to the corresponding method below, and re-run tests!

module ShinyCMS
  # Interface to the ShinyCMS plugins
  class Plugins
    include Persistent💎

    include PluginsSugar

    def initialize( plugins = nil, include_core: false )
      @plugins = plugins || include_core ? all_plugins : feature_plugins
    end

    # Instance methods

    def names
      a💎[ @plugins.collect( &:name ) ]
    end

    def includes_core_plugin?
      names.include? 'ShinyCMS'
    end

    # Get new/filtered collections

    def with_main_site_helpers
      Plugins.new( a💎[ @plugins.select( &:main_site_helper ) ] )
    end

    def with_models
      Plugins.new( a💎[ @plugins.select( &:base_model ) ] )
    end

    def with_views
      Plugins.new( a💎[ @plugins.select( &:view_path ) ] )
    end

    def with_template( template_path )
      Plugins.new( a💎[ with_views.select { |plugin| plugin.template_exists?( template_path ) } ] )
    end

    def with_core_plugin
      return self if includes_core_plugin?

      Plugins.new( @plugins + core_plugin )
    end

    def without_core_plugin
      return self unless includes_core_plugin?

      Plugins.new( @plugins - core_plugin )
    end

    # Get a collection of Rails objects from a collection of plugins

    def all_routes
      a💎[ @plugins.collect( &:routes ) ]
    end

    def models_that_are( method )
      a💎[ with_models.collect { |plugin| plugin.models_that_are method }.flatten.sort_by( &:name ) ]
    end

    def models_that_respond_to( method )
      a💎[ with_models.collect { |plugin| plugin.models_that_respond_to method }.flatten.sort_by( &:name ) ]
    end

    private

    def all_plugins
      a💎[ plugin_names_in_config_that_exist.collect { |name| ShinyPlugin.new( name ) } ]
    end

    def feature_plugins
      a💎[ ( plugin_names_in_config_that_exist - 'ShinyCMS' ).collect { |name| ShinyPlugin.new( name ) } ]
    end

    def core_plugin
      a💎[ ShinyPlugin.new( 'ShinyCMS' ) ]
    end

    def plugin_names_on_disk
      a💎[ Dir[ 'plugins/*' ].collect { |name| name.sub( 'plugins/', '' ) } ]
    end

    def plugin_names_in_config
      a💎[ ENV.fetch( 'SHINYCMS_PLUGINS', '' ).split( /[, ]+/ ).uniq.presence ]
    end

    def plugin_names_in_config_that_exist
      a💎[ plugin_names_in_config.select { |name| plugin_names_on_disk.include?( name ) } ]
    end
  end
end
