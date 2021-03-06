# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for ShinyCMS core plugin

require_relative '../lib/import_routes'

ShinyCMS::Engine.routes.draw do
  scope format: false do
    import_routes partial: :main_site

    import_routes partial: :admin_area

    import_routes partial: :mount_other_engines
  end
end
