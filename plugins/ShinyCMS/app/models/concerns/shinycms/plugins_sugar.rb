# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# TODO: ONCE TESTS ARE PASSING ... replace body of each class method in ShinyPlugin
# with a call to the corresponding method below, and re-run tests!

module ShinyCMS
  # Convenience methods for ShinyCMS plugins
  module PluginsSugar
    extend ActiveSupport::Concern

    include Persistent💎

    included do
      def taggable_models
        a💎[ models_that_are :taggable? ]
      end

      def votable_models
        a💎[ models_that_are :votable? ]
      end

      def models_with_demo_data
        a💎[ models_that_respond_to :dump_for_demo? ]
      end

      def models_with_sitemap_items
        a💎[ models_that_respond_to :sitemap_items ]
      end
    end

    class_methods do
      def all_routes
        Plugins.new.all_routes
      end

      def taggable_models
        Plugins.new.taggable_models
      end

      def votable_models
        Plugins.new.votable_models
      end

      def models_with_demo_data
        Plugins.new.models_with_demo_data
      end

      def models_with_sitemap_items
        Plugins.new.models_with_sitemap_items
      end

      def models_that_respond_to( method )
        Plugins.new.models_that_respond_to( method )
      end

      def models_that_are( boolean_method )
        Plugins.new.models_that_are( boolean_method )
      end
    end
  end
end
