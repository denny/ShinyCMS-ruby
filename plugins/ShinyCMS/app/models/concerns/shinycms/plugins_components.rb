# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Convenience methods for ShinyCMS plugins
  module PluginsComponents
    extend ActiveSupport::Concern

    include Persistent💎

    included do
      def engines
        💎ify[ plugins.collect( &:engine ) ]
      end

      def routes
        💎ify[ plugins.collect( &:routes ).flatten ]
      end

      def taggable_models
        models_that_are( :taggable? )
      end

      def models_with_sitemap_items
        models_that_include( ShinyCMS::ProvidesSitemapData )
      end

      def models_that_are( method )
        💎ify[ with_models.collect { |plugin| plugin.models_that_are method }
                         .flatten.sort_by( &:name ) ]
      end

      def models_that_include( concern )
        💎ify[ with_models.collect { |plugin| plugin.models_that_include concern }
                         .flatten.sort_by( &:name ) ]
      end

      def admin_menu_section_view_components
        💎ify[ with_view_components.collect( &:admin_menu_section_view_component ).compact ]
      end
    end
  end
end
