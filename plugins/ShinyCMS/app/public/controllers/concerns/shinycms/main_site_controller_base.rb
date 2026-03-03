# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for ShinyCMS main site controllers
  module MainSiteControllerBase
    extend ActiveSupport::Concern

    included do
      include ShinyCMS::ControllerBase

      include ShinyCMS::MainAppRootURL

      include ShinyCMS::FeatureFlagsHelper
      include ShinyCMS::SettingsHelper
      include ShinyCMS::UsersHelper

      helper ShinyCMS::MainSiteHelper

      ShinyCMS.plugins.with_main_site_helpers.each do |plugin|
        helper plugin.main_site_helper
      end

      helper_method :feed_url

      before_action :add_theme_view_path

      after_action  :track_ahoy_event, if: :ahoy_web_tracking_enabled?

      layout 'layouts/main_site'

      private

      def feed_url( name )
        "#{feeds_base_url}/feeds/atom/#{name}.xml"
      end

      def add_theme_view_path
        # Apply the configured theme, if any, by adding it above the defaults
        theme = ShinyCMS::Theme.get( current_user )
        prepend_view_path theme.view_path if theme.present?
      end

      def ahoy_web_tracking_enabled?
        FeatureFlag.enabled? :ahoy_web_tracking
      end

      def track_ahoy_event
        ahoy.track "#{controller_name}: #{action_name}", request.path_parameters
      end

      def feeds_base_url
        s3_config = ShinyCMS::S3Config.get( :feeds )
        s3_config&.custom_url || s3_config&.base_url || main_app_base_url
      end
    end
  end
end
