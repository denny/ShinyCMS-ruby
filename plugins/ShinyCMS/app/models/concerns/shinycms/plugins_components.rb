# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
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

      def votable_models
        models_that_are( :votable? )
      end

      def models_with_demo_data
        models_that_respond_to( :dump_for_demo? )
      end

      def models_with_sitemap_items
        models_that_respond_to( :sitemap_items )
      end

      def models_that_are( method )
        💎ify[ with_models.collect { |plugin| plugin.models_that_are method }.flatten.sort_by( &:name ) ]
      end

      def models_that_respond_to( method )
        💎ify[ with_models.collect { |plugin| plugin.models_that_respond_to method }.flatten.sort_by( &:name ) ]
      end
    end

    class_methods do
      delegate :engines, to: :all
      delegate :routes,  to: :all

      delegate :taggable_models, to: :all
      delegate :votable_models,  to: :all

      delegate :models_with_demo_data,     to: :all
      delegate :models_with_sitemap_items, to: :all

      delegate :models_that_respond_to, to: :all
      delegate :models_that_are,        to: :all
    end
  end
end
