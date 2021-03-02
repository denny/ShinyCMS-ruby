# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes file partial to mount the ShinyCMS core plugin and enabled feature plugins
# See ShinyHostApp config/routes.rb for example usage

# Core plugin
mount ShinyCMS::Engine, at: '/', as: :shinycms

# Feature plugins
ShinyCMS.plugins.engines.each do |engine|
  mount engine, at: '/'
end
