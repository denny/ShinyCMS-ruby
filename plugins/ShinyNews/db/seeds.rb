# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_news:db:seed

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_feature_flag( name: 'news',           description: 'News / press-releases (ShinyNews plugin)' )
seeder.seed_feature_flag( name: 'news_upvotes',   description: 'Allow upvotes on news posts'   )
seeder.seed_feature_flag( name: 'news_downvotes', description: 'Allow downvotes on news posts' )

category = seeder.seed_standard_admin_capabilities( category: :news_posts )
category.capabilities.find_or_create_by!( name: 'change_author' )
