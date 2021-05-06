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
      CORE_MENU_SECTION_COMPONENTS = [
        ShinyCMS::Admin::Menu::EmailComponent,
        ShinyCMS::Admin::Menu::ConsentVersionsComponent,
        ShinyCMS::Admin::Menu::OtherComponent,
        ShinyCMS::Admin::Menu::UsersComponent,
        ShinyCMS::Admin::Menu::StatsComponent,
        ShinyCMS::Admin::Menu::SettingsComponent,
        ShinyCMS::Admin::Menu::SidekiqComponent,
        ShinyCMS::Admin::Menu::CoverbandComponent
      ].freeze
      private_constant :CORE_MENU_SECTION_COMPONENTS

      def initialize( current_user: )
        @feature_menu_partials = feature_plugin_admin_menu_partials
        @menu_sections = menu_sections
        @current_user = current_user
      end

      def menu_sections
        ShinyCMS.plugins.admin_menu_section_view_components + CORE_MENU_SECTION_COMPONENTS
      end

      def feature_plugin_admin_menu_partials
        plugins = ShinyCMS.plugins.with_partial( 'admin/menu/_section.html.erb' )
        return unless plugins

        plugins.collect { |plugin| plugin.partial( 'admin/menu/section' ) }
      end
    end
  end
end
