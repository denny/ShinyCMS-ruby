# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This file has to be copied to `/config/sitemap.rb` in your
# main application or the sitemap_generator gem will not work
#
# You can copy it manually or use `rails shiny_seo:install:config`

require Rails.root.join 'plugins/ShinySEO/config/sitemap' if File.exist? 'plugins/ShinySEO/config/sitemap.rb'
