# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Helper methods for dealing with plugins
module ShinyPluginHelper
  def plugin_loaded?( plugin_name )
    ::Plugin.loaded? plugin_name
  end

  def plugins_with_main_site_menu_templates
    ::Plugin.with_template( 'menu/_section.html.erb' )
  end

  def plugins_with_admin_toolbar_templates
    ::Plugin.with_template( 'admin/toolbar/_section.html.erb' )
  end
end
