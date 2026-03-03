# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
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
        @current_user  = current_user
        @menu_sections = menu_sections
      end

      def menu_sections
        ShinyCMS.plugins.admin_menu_section_view_components + CORE_MENU_SECTION_COMPONENTS
      end
    end
  end
end
