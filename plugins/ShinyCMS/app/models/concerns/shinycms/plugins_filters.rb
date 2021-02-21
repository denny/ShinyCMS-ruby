# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Convenience methods for ShinyCMS plugins
  module PluginsFilters
    extend ActiveSupport::Concern

    include Persistent💎

    included do
      def with_main_site_helpers
        ShinyCMS::Plugins.get( plugins.select { |plugin| plugin if plugin.main_site_helper } )
      end

      def with_models
        ShinyCMS::Plugins.get( plugins.select { |plugin| plugin if plugin.base_model } )
      end

      def with_views
        ShinyCMS::Plugins.get( plugins.select { |plugin| plugin if plugin.view_path } )
      end

      def with_partial( partial )
        ShinyCMS::Plugins.get( with_views.select { |plugin| plugin.view_file_exists?( partial ) } ).to_a
      end
    end

    class_methods do
      delegate :with_main_site_helpers, to: :get
      delegate :with_views,             to: :get
    end
  end
end
