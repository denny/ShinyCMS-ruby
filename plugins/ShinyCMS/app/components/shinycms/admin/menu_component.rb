# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Component to render admin sidebar menu
    class MenuComponent < ApplicationComponent
      # TODO: Whittle this list down as bits of this functionality move to plugins
      CORE_MENU_SECTIONS = %w[
        email
        consent_versions
        other
        users
        stats
        settings
        sidekiq_web
        coverband
      ].freeze
      private_constant :CORE_MENU_SECTIONS

      def initialize( current_user: )
        @current_user = current_user
        @menu_sections = admin_menu_sections
      end

      def admin_menu_sections
        # TODO: Allow each admin to customise the menu order. Apply that order here?
        feature_plugin_admin_menu_partials + core_plugin_admin_menu_partials
      end

      def core_plugin_admin_menu_partials
        CORE_MENU_SECTIONS.collect { |name| "admin/menu/#{name}" }
      end

      def feature_plugin_admin_menu_partials
        plugins = ShinyCMS.plugins.with_partial( 'admin/menu/_section.html.erb' )
        return unless plugins

        plugins.collect { |plugin| plugin.partial( 'admin/menu/section' ) }
      end
    end
  end
end
