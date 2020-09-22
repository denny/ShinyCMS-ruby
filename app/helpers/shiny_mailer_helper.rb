# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Helper to add useful common behaviour to ShinyCMS mailers
module ShinyMailerHelper
  include ShinySiteNameHelper

  def add_view_paths( plugin_path = nil )
    # Add the default templates directory to the top of view_paths
    prepend_view_path 'app/views/shinycms'
    # If a plugin view path was passed in, add that above the main app path
    prepend_view_path plugin_path if valid_plugin_path?
    # Apply the configured theme, if any, by adding it above the defaults
    prepend_view_path ::Theme.current.view_path if ::Theme.current
  end

  def valid_plugin_path?( plugin_path = nil )
    plugin_path.present? && plugin_path.starts_with?( 'plugins/' ) && plugin_path.ends_with?( 'app/views' )
  end

  def default_email
    ::Setting.get( :default_email ) || ENV[ 'DEFAULT_EMAIL' ]
  end

  def track_opens?
    ::Setting.get( :track_opens )&.downcase == 'yes'
  end

  def track_clicks?
    ::Setting.get( :track_clicks )&.downcase == 'yes'
  end
end
