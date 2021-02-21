# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Seed data (feature flags and admin capabilities)

# You can load or reload this data using the following rake task:
# rails shiny_blogs:db:seed

# Feature flags
flag1 = ShinyCMS::FeatureFlag.find_or_create_by!( name: 'shiny_blogs' )
flag1.update!(
  description:           'Enable multi-blogs feature, provided by ShinyBlogs plugin',
  enabled:               true,
  enabled_for_logged_in: true,
  enabled_for_admins:    true
)
flag2 = ShinyCMS::FeatureFlag.find_or_create_by!( name: 'shiny_blogs_votes' )
flag2.update!(
  description:           'Enable votes on blog posts',
  enabled:               true,
  enabled_for_logged_in: true,
  enabled_for_admins:    true
)
flag3 = ShinyCMS::FeatureFlag.find_or_create_by!( name: 'shiny_blogs_downvotes' )
flag3.update!(
  description:           'Enable down-votes on blog posts',
  enabled:               true,
  enabled_for_logged_in: true,
  enabled_for_admins:    true
)

# Admin capabilities
cc1 = ShinyCMS::CapabilityCategory.find_or_create_by!( name: 'shiny_blogs_blogs' )
cc1.capabilities.find_or_create_by!( name: 'list'    )
cc1.capabilities.find_or_create_by!( name: 'add'     )
cc1.capabilities.find_or_create_by!( name: 'edit'    )
cc1.capabilities.find_or_create_by!( name: 'destroy' )

cc2 = ShinyCMS::CapabilityCategory.find_or_create_by!( name: 'shiny_blogs_blog_posts' )
cc2.capabilities.find_or_create_by!( name: 'list'          )
cc2.capabilities.find_or_create_by!( name: 'add'           )
cc2.capabilities.find_or_create_by!( name: 'edit'          )
cc2.capabilities.find_or_create_by!( name: 'destroy'       )
cc2.capabilities.find_or_create_by!( name: 'change_author' )
