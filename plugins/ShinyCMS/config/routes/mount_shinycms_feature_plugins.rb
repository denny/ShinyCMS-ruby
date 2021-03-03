# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes file partial to mount any ShinyCMS feature plugins that are enabled
# See ShinyHostApp config/routes.rb for example usage

ShinyCMS.plugins.engines.each do |engine|
  mount engine, at: '/'
end
