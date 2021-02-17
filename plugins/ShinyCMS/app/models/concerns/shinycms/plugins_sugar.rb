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
        models_that_are( :taggable? ).to_a
      end

      def votable_models
        models_that_are( :votable? ).to_a
      end

      def models_with_demo_data
        models_that_respond_to( :dump_for_demo? ).to_a
      end

      def models_with_sitemap_items
        models_that_respond_to( :sitemap_items ).to_a
      end

      def unshift( plugin )
        Plugins.new( _plugins.unshift( build_plugin( plugin ) ) )
      end
    end

    class_methods do
      def all
        new.unshift( 'ShinyCMS' )
      end

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

      delegate :include?, to: :new

      delegate :taggable_models, to: :new
      delegate :votable_models,  to: :new

      delegate :models_with_demo_data,     to: :new
      delegate :models_with_sitemap_items, to: :new

      delegate :models_that_respond_to, to: :new
      delegate :models_that_are,        to: :new

      # delegate :with_main_site_helpers, to: :new
      # delegate :with_models,            to: :new
      # delegate :with_views,             to: :new
      delegate :with_template,          to: :new
    end
  end
end
