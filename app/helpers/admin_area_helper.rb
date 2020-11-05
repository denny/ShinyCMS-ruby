# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Helper methods for admin area
module AdminAreaHelper
  def plugin_breadcrumb_link_text_and_path( plugin_name, controller_name )
    [
      I18n.t( "#{plugin_name.underscore}.admin.#{controller_name}.breadcrumb" ),
      plugin_name.constantize::Engine.routes.url_helpers.public_send( "#{controller_name}_path" )
    ]
  end

  def plugins_for_admin_menu
    ShinyPlugin.with_template( 'admin/menu/_section.html.erb' )
  end

  def plugins_for_admin_other_menu
    ShinyPlugin.with_template( 'admin/menu/_other_item.html.erb' )
  end

  def plugins_for_edit_capabilities
    ShinyPlugin.with_template( 'admin/user/_edit_capabilities.html.erb' )
  end

  def capability( name:, category: )
    Capability.find_by( name: name, category: category )
  end

  def capability_category( name )
    CapabilityCategory.find_by( name: name.to_s )
  end

  def render_capability_category( form, category, capabilities, show )
    render partial: 'capability_category', locals: {
      f: form,
      category: category,
      category_capabilities: capabilities,
      show: show
    }
  end

  def render_capability_checkbox( form, capability, capability_category )
    return if capability == 'skip'

    render partial: 'capability_checkbox', locals: {
      f: form,
      capability: capability,
      category: capability_category
    }
  end

  def render_admin_menu_section_start( text, icon = nil )
    render partial: 'admin/menu/menu_section_start',
           locals: { text: text, icon: icon }
  end

  def render_admin_menu_section_end
    render partial: 'admin/menu/menu_section_end'
  end

  def render_admin_menu_section( text, icon = nil, &block )
    section = render_admin_menu_section_start( text, icon )
    section << capture( &block )
    section << render_admin_menu_section_end
  end

  def render_admin_menu_item( text, link, icon = nil )
    render partial: 'admin/menu/menu_item',
           locals: { text: text, link: link, icon: icon }
  end

  def render_admin_menu_item_if( condition, text, link, icon = nil )
    render_admin_menu_item( text, link, icon ) if condition
  end
end
