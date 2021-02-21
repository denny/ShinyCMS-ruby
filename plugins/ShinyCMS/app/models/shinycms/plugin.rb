# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Provides convenience methods for interacting with ShinyCMS plugins
  class Plugin
    include Persistent💎

    attr_reader :name

    def initialize( plugin_name )
      raise ArgumentError, "Plugin '#{plugin_name}' is not available" unless ShinyCMS::Plugin.available? plugin_name

      @name = plugin_name.to_sym
    end

    def self.get( plugin )
      return plugin if plugin.is_a? ShinyCMS::Plugin
      return new( plugin ) if available? plugin
    end

    def self.available?( plugin_name )
      available_plugin_names.include? plugin_name.to_sym
    end

    def self.available_plugin_names
      @available_plugin_names ||= a💎[ :ShinyCMS, *ShinyCMS::Plugins.all_plugin_names ]
    end

    def engine
      @engine ||= to_constant::Engine
    end

    def routes
      engine.routes.routes.routes # er, okay
    end

    def base_model
      return @base_model if defined? @base_model

      @base_model = to_constant::ApplicationRecord if defined? to_constant::ApplicationRecord
    end

    def main_site_helper
      return @main_site_helper if defined? @main_site_helper

      @main_site_helper = to_constant::MainSiteHelper if defined? to_constant::MainSiteHelper
    end

    def models_that_are( method )
      base_model.descendants.select( &method )
    end

    def models_that_respond_to( method )
      base_model.descendants.select { |model| model.respond_to?( method ) }
    end

    def view_path
      return @view_path if defined? @view_path

      path = "plugins/#{name}/app/views/#{underscore}"

      @view_path = path if Dir.exist? Rails.root.join( path )
    end

    def view_file_exists?( view_file )
      File.exist? Rails.root.join( "#{view_path}/#{view_file}" )
    end

    def partial( location )
      "#{underscore}/#{location}"
    end

    def underscore
      name.to_s.underscore
    end

    def to_constant
      name.to_s.constantize
    end
  end
end
