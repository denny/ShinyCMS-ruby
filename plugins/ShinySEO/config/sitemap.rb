# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# The main_app_config_sitemap.rb file must be copied to /config/sitemap.rb or
# the sitemap_generator gem, which powers the sitemap feature, will not work
#
# You can copy it manually, or use `rails shiny_seo:install:config`

return unless ShinyCMS.plugins.loaded? :ShinySEO

ShinySEO::Sitemap.new.generate
