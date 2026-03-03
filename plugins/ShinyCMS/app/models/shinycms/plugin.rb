# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Methods to get and query a single ShinyCMS plugin
  class Plugin
    include Persistent💎

    attr_reader :name

    def initialize( plugin_name )
      raise ArgumentError, "Plugin '#{plugin_name}' is not available" unless Plugin.available? plugin_name

      @name = plugin_name.to_sym
    end

    def self.get( plugin )
      return plugin if plugin.is_a? ShinyCMS::Plugin

      return new( plugin ) if available? plugin
    end

    def self.available?( plugin_name )
      all_plugin_names.include? plugin_name.to_sym
    end

    def self.all_plugin_names
      a💎[ :ShinyCMS, *ShinyCMS::Plugins.feature_plugin_names ]
    end

    def engine
      to_constant::Engine
    end

    def routes
      engine.routes.routes.routes # er, okay
    end

    def url_helpers
      engine.routes.url_helpers
    end

    def base_model
      to_constant::ApplicationRecord if defined? to_constant::ApplicationRecord
    end

    def main_site_helper
      to_constant::MainSiteHelper if defined? to_constant::MainSiteHelper
    end

    def models_that_are( method )
      base_model.descendants.select( &method )
    end

    def models_that_include( concern )
      base_model.descendants.select { |model| model.include?( concern ) }
                .sort_by( &:name )
    end

    def view_path
      path = "plugins/#{name}/app/views/#{underscore}"

      return unless Rails.root.join( path ).exist?

      path
    end

    def view_file_exists?( view_file )
      Rails.root.join( "#{view_path}/#{view_file}" ).exist?
    end

    def partial( location )
      "#{underscore}/#{location}"
    end

    def view_components?
      Dir.exist? "plugins/#{name}/app/components/#{underscore}"
    end

    def admin_menu_section_view_component
      return unless defined? to_constant::Admin::Menu::SectionComponent

      to_constant::Admin::Menu::SectionComponent
    end

    def underscore
      name.to_s.underscore
    end

    def to_constant
      name.to_s.constantize
    end
  end
end
