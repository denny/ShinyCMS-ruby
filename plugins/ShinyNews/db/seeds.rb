# frozen_string_literal: true

# This file contains supporting data required by the ShinyNews plugin for ShinyCMS
# (specifically, a feature flag, and the admin user capabilities for authorisation)
#
# You can load or reload this data using the following rake task:
# rails shiny_news:db:seed

# Add feature flag
news_flag = FeatureFlag.find_or_create_by!( name: 'news' )
news_flag.update!(
  description: 'Enable news section, provided by ShinyNews plugin',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)
news_votes_flag = FeatureFlag.find_or_create_by!( name: 'news_votes' )
news_votes_flag.update!(
  description: 'Enable votes on news posts',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)
news_downvotes_flag = FeatureFlag.find_or_create_by!( name: 'news_downvotes' )
news_downvotes_flag.update!(
  description: 'Enable down-votes on news posts',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)

# Add admin capabilities
news_cc = CapabilityCategory.find_or_create_by!( name: 'shiny_news_posts' )
news_cc.capabilities.find_or_create_by!( name: 'list'          )
news_cc.capabilities.find_or_create_by!( name: 'add'           )
news_cc.capabilities.find_or_create_by!( name: 'edit'          )
news_cc.capabilities.find_or_create_by!( name: 'destroy'       )
news_cc.capabilities.find_or_create_by!( name: 'change_author' )
