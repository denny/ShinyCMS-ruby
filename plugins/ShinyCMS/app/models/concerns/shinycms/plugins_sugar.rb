# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# TODO: ONCE TESTS ARE PASSING ... replace body of each class method in Plugin
# with a call to the corresponding method below, and re-run tests!

module ShinyCMS
  # Convenience methods for ShinyCMS plugins
  module PluginsSugar
    extend ActiveSupport::Concern

    include Persistent💎

    included do
      def taggable_models
        models_that_are :taggable?
      end

      def votable_models
        models_that_are :votable?
      end

      def models_with_demo_data
        models_that_respond_to :dump_for_demo?
      end

      def models_with_sitemap_items
        models_that_respond_to :sitemap_items
      end

      def _unshift( plugin )
        Plugins.new( _plugins.unshift( build_plugin( plugin ) ) )
      end
    end

    class_methods do
      def all
        new._unshift( 'ShinyCMS' )
      end

      delegate :names,      to: :new
      delegate :all_routes, to: :new

      delegate :taggable_models, to: :new
      delegate :votable_models,  to: :new

      delegate :models_with_demo_data,     to: :new
      delegate :models_with_sitemap_items, to: :new

      delegate :models_that_respond_to, to: :new
      delegate :models_that_are,        to: :new

      delegate :with_models, to: :new
    end
  end
end
