# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Provides convenience methods for interacting with ShinyCMS plugins
  class Plugin
    attr_reader :name

    def initialize( name )
      return unless Plugins.available_plugin_names.include? name

      @name = name
    end

    def engine
      @engine ||= name.constantize::Engine
    end

    def base_model
      @base_model ||= name.constantize::ApplicationRecord if defined? name.constantize::ApplicationRecord
    end

    def main_site_helper
      @main_site_helper ||= name.constantize::MainSiteHelper if defined? name.constantize::MainSiteHelper
    end

    def models_that_are( method )
      base_model.descendants.select( &method )
    end

    def models_that_respond_to( method )
      base_model.descendants.select { |model| model.respond_to?( method ) }
    end

    def view_path
      return unless File.exist? Rails.root.join( "plugins/#{name}/app/views/" )

      "plugins/#{name}/app/views/#{name.underscore}"
    end

    def template_exists?( template_path )
      File.exist? "#{view_path}/#{template_path}"
    end

    def routes
      engine.routes.routes.routes # er, okay
    end
  end
end
