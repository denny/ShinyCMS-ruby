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
    end

    class_methods do
      delegate :include?, to: :get
      delegate :loaded?,  to: :get

      delegate :with_main_site_helpers, to: :get
      delegate :with_views,             to: :get

      delegate :taggable_models, to: :get
      delegate :votable_models,  to: :get

      delegate :models_with_demo_data,     to: :get
      delegate :models_with_sitemap_items, to: :get

      delegate :models_that_respond_to, to: :get
      delegate :models_that_are,        to: :get
    end
  end
end
