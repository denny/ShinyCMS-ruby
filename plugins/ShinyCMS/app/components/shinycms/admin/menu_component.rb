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
        sidekiq
        coverband
      ].freeze
      private_constant :CORE_MENU_SECTIONS

      def initialize( current_user: )
        @feature_menu_sections = feature_plugin_admin_menu_partials
        @core_menu_sections = CORE_MENU_SECTIONS
        @current_user = current_user
      end

      def feature_plugin_admin_menu_partials
        plugins = ShinyCMS.plugins.with_partial( 'admin/menu/_section.html.erb' )
        return unless plugins

        plugins.collect { |plugin| plugin.partial( 'admin/menu/section' ) }
      end
    end
  end
end
