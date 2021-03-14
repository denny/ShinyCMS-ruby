# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Import routes from 'partial routes files' into a routes.draw block

# Pass in the name (without .rb) of a routes partial file, and
# optionally, the plugin that provides that partial (defaults to the
# ShinyCMS core plugin if not specified). The file must be located in
# in the config/routes directory in a plugin, and should contain one
# or more valid route definitions that go inside a routes.draw block.
# Both params can be passed as a symbol or a string.
#
# Examples:
#   import_routes partial: :admin_area
#   import_routes partial: :top_level_pages, plugin: :ShinyPages

def import_routes( partial:, plugin: :ShinyCMS )
  full_path = Rails.root.join "plugins/#{plugin}/config/routes/#{partial}.rb"

  raise ArgumentError, 'Partial file not found' unless File.file? full_path

  instance_eval( File.read( full_path ) )
end
