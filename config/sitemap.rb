# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# If a plugin wants to add items to the sitemap, the relevant model(s) should have
# a `sitemap_items` class method which returns an array of `ShinySEO::SitemapItem`s,
# and a `.path` instance method (which SitemapItem uses to build a link to the item)

ShinySEO::Sitemap.generate
