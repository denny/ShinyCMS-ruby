# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Convenience methods for ShinyCMS plugins
  module PluginsSugar
    extend ActiveSupport::Concern

    include Persistent💎

    included do
      def taggable_models
        models_that_are( :taggable? )
      end

      def votable_models
        models_that_are( :votable? )
      end

      def models_with_demo_data
        models_that_respond_to( :dump_for_demo? )
      end

      def models_with_sitemap_items
        models_that_respond_to( :sitemap_items )
      end

      def unshift( plugin )
        Plugins.new( _plugins.unshift( build_plugin( plugin ) ) )
      end
    end

    class_methods do
      delegate :include?, to: :new

      delegate :models_that_respond_to, to: :new
      delegate :models_that_are,        to: :new

      def all
        new.unshift( 'ShinyCMS' )
      end

      # Each .to_a call below converts from Persistent💎 array to standard Array

      def all_routes
        all.all_routes.to_a
      end

      def names
        new.names.to_a
      end

      def loaded
        new.to_a
      end

      def with_main_site_helpers
        new.with_main_site_helpers.to_a
      end

      def with_views
        new.with_views.to_a
      end

      def with_template( template_path )
        new.with_template( template_path ).to_a
      end

      def taggable_models
        new.taggable_models.to_a
      end

      def votable_models
        new.votable_models.to_a
      end

      def models_with_demo_data
        new.models_with_demo_data.to_a
      end

      def models_with_sitemap_items
        new.models_with_sitemap_items.to_a
      end
    end
  end
end
