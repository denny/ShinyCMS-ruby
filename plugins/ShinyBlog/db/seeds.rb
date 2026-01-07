# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_blog:db:seed

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_feature_flag( name: :blog,           description: 'Blog feature (ShinyBlog plugin)' )
seeder.seed_feature_flag( name: :blog_upvotes,   description: 'Enable upvotes on blog posts'    )
seeder.seed_feature_flag( name: :blog_downvotes, description: 'Enable downvotes on blog posts'  )

category = seeder.seed_standard_admin_capabilities( category: :blog_posts )
category.capabilities.find_or_create_by!( name: 'change_author' )
