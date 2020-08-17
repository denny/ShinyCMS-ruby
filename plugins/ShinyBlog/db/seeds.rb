# frozen_string_literal: true

# ============================================================================
# Project:   ShinyBlog plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyBlog/db/seeds.rb
# Purpose:   Seed data (feature flags and admin capabilities)
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

# You can load or reload this data using the following rake task:
# rails shiny_blog:db:seed

# Add feature flags

flag = FeatureFlag.find_or_create_by!( name: 'blog' )
flag.update!(
  description: 'Enable blog section, provided by ShinyBlog plugin',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)

flag = FeatureFlag.find_or_create_by!( name: 'blog_votes' )
flag.update!(
  description: 'Enable votes on blog posts',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)

flag = FeatureFlag.find_or_create_by!( name: 'blog_downvotes' )
flag.update!(
  description: 'Enable down-votes on blog posts',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)

# Add admin capabilities

category = CapabilityCategory.find_or_create_by!( name: 'blog_posts' )
category.capabilities.find_or_create_by!( name: 'list'          )
category.capabilities.find_or_create_by!( name: 'add'           )
category.capabilities.find_or_create_by!( name: 'edit'          )
category.capabilities.find_or_create_by!( name: 'destroy'       )
category.capabilities.find_or_create_by!( name: 'change_author' )
