# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common code to be included in all ShinyCMS controllers (main site and admin area)
  module ControllerBase
    extend ActiveSupport::Concern

    included do
      include ShinyCMS::WithFeatureFlags

      include Pagy::Backend

      helper Pagy::Frontend

      helper Rails.application.routes.url_helpers

      helper_method :pagy_url_for, :recaptcha_v2_site_key, :recaptcha_v3_site_key, :recaptcha_checkbox_site_key

      before_action :store_user_location!, if: :storable_location?

      before_action :set_view_paths

      private

      def store_user_location!
        store_location_for :user, request.fullpath
      end

      def storable_location?
        request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
      end

      def set_view_paths
        # Add the default templates directory to the top of view_paths
        prepend_view_path 'plugins/ShinyCMS/app/views/shinycms'

        # Add the default templates directory for any loaded plugins above that
        ShinyCMS.plugins.with_views.each do |plugin|
          prepend_view_path plugin.view_path
        end
      end

      # Change pager link format from admin/action?page=3&items=12 to admin/action/page/3/items/12
      # rubocop:disable Lint/UnusedMethodArgument
      def pagy_url_for( pagy, page, absolute: false, html_escaped: false )
        params = request.query_parameters.merge( page: page, items: pagy.vars[:limit], only_path: true )
        url_for( params )
      end
      # rubocop:enable Lint/UnusedMethodArgument

      def recaptcha_v3_site_key
        ENV[ 'RECAPTCHA_V3_SITE_KEY' ]
      end

      def recaptcha_v2_site_key
        ENV[ 'RECAPTCHA_V2_SITE_KEY' ]
      end

      def recaptcha_checkbox_site_key
        ENV[ 'RECAPTCHA_CHECKBOX_SITE_KEY' ]
      end
    end

    class_methods do
      def recaptcha_v3_secret_key
        ENV[ 'RECAPTCHA_V3_SECRET_KEY' ]
      end

      def recaptcha_v2_secret_key
        ENV[ 'RECAPTCHA_V2_SECRET_KEY' ]
      end

      def recaptcha_checkbox_secret_key
        ENV[ 'RECAPTCHA_CHECKBOX_SECRET_KEY' ]
      end
    end
  end
end
