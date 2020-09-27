# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Helper methods for admin area
module AdminAreaHelper
  def plugins_for_admin_menu
    ::Plugin.with_template( 'admin/menu/_section.html.erb' )
  end

  def plugins_for_admin_other_menu
    ::Plugin.with_template( 'admin/menu/_other_item.html.erb' )
  end

  def plugins_for_edit_capabilities
    ::Plugin.with_template( 'admin/user/_edit_capabilities.html.erb' )
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
    render partial: 'admin/menu/menu__section_start',
           locals: { text: text, icon: icon }
  end

  def render_admin_menu_section_end
    render partial: 'admin/menu/menu__section_end'
  end

  def render_admin_menu_section( text, icon = nil, &contents )
    section = render_admin_menu_section_start( text, icon )
    section << capture do
      contents.call
    end
    section << render_admin_menu_section_end
  end

  def render_admin_menu_item( text, link, icon = nil )
    render partial: 'admin/menu/menu__item',
           locals: { text: text, link: link, icon: icon }
  end

  def render_admin_menu_item_if( condition, text, link, icon = nil )
    render_admin_menu_item( text, link, icon ) if condition
  end
end
