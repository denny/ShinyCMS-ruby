# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for admin area
  module AdminAreaHelper
    def blazer_controller?
      controller.is_a? Blazer::BaseController
    end

    def rep_controller?
      controller.is_a? RailsEmailPreview::ApplicationController
    end

    def shinycms_admin_controller?
      controller.is_a?( ShinyCMS::AdminController ) && !blazer_controller? && !rep_controller?
    end

    def coverband_web_ui_enabled?
      ENV['DISABLE_COVERBAND_WEB_UI']&.downcase != 'true'
    end

    def sidekiq_web_enabled?
      ENV['DISABLE_SIDEKIQ_WEB']&.downcase != 'true'
    end

    def plugin_breadcrumb_link_text_and_path( plugin, controller_name )
      [
        I18n.t( "#{plugin.underscore}.admin.#{controller_name}.breadcrumb" ),
        plugin.engine.routes.url_helpers.public_send( "#{controller_name}_path" )
      ]
    end

    def plugins_for_admin_menu
      ShinyCMS.plugins.with_partial 'admin/menu/_section.html.erb'
    end

    def plugins_for_admin_other_menu
      ShinyCMS.plugins.with_partial 'admin/menu/_other_item.html.erb'
    end

    def plugins_for_edit_capabilities
      ShinyCMS.plugins.with_partial 'admin/user/_edit_capabilities.html.erb'
    end

    def capability( name:, category: )
      ShinyCMS::Capability.find_by( name: name, category: category )
    end

    def capability_category( name )
      ShinyCMS::CapabilityCategory.find_by( name: name.to_s )
    end

    def render_capability_category( form, category, capabilities, show )
      render partial: 'capability_category', locals: {
        f:                     form,
        category:              category,
        category_capabilities: capabilities,
        show:                  show
      }
    end

    def render_capability_checkbox( form, capability, capability_category )
      return if capability == 'skip'

      render partial: 'capability_checkbox', locals: {
        f:          form,
        capability: capability,
        category:   capability_category
      }
    end

    def render_admin_menu_section_start( text, icon = nil, show: nil )
      render partial: 'admin/menu/menu_section_start',
             locals:  { text: text, icon: icon, show: show }
    end

    def render_admin_menu_section_end
      render partial: 'admin/menu/menu_section_end'
    end

    def render_admin_menu_section( text, icon = nil, show: nil, &block )
      section = render_admin_menu_section_start( text, icon, show: show )
      section << capture( &block )
      section << render_admin_menu_section_end
    end

    def render_admin_menu_item( text, link, icon = nil, active: nil )
      render partial: 'admin/menu/menu_item',
             locals:  { text: text, link: link, icon: icon, set_as_active: active }
    end

    def render_admin_menu_item_if( condition, text, link, icon = nil, active: nil )
      render_admin_menu_item( text, link, icon, active: active ) if condition
    end
  end
end
