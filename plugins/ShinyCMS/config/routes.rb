# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes for ShinyCMS core plugin

ShinyCMS::Engine.routes.draw do
  scope format: false do
    draw :main_site
    draw :admin_area
    draw :tools
  end
end
