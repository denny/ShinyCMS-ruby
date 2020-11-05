# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Helper methods for dealing with plugins
module ShinyPluginHelper
  def plugin_loaded?( plugin_name )
    ShinyPlugin.loaded? plugin_name
  end

  def plugins_with_main_site_head_templates
    ShinyPlugin.with_template( 'includes/_head_part.html.erb' )
  end

  def plugins_with_main_site_menu_templates
    ShinyPlugin.with_template( 'menu/_section.html.erb' )
  end

  def plugins_with_admin_toolbar_templates
    ShinyPlugin.with_template( 'admin/toolbar/_section.html.erb' )
  end

  def valid_plugin_path?( plugin_path = nil )
    plugin_path.present? && plugin_path.starts_with?( 'plugins/' ) && plugin_path.ends_with?( 'app/views' )
  end
end
