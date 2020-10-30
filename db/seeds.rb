# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This file contains any data which is either necessary to get ShinyCMS running,
# or which might provide useful hints for configuration after that.
#
# It is used to populate the database when you create it with `rails db:setup` or re-create it
# with `rails db:reset`. You can also reload this data at any time using `rails db:seed`.

# Capabilities (for user authorisation, via Pundit)
def add_capabilities( category:, capabilities: )
  capability_category = CapabilityCategory.create_or_find_by!( name: category )

  capabilities.each do |capability_name|
    capability_category.capabilities.create_or_find_by!(
      name: capability_name
    )
  end
end

add_capabilities(
  category: 'general',
  capabilities: %w[ view_admin_area view_admin_toolbar manage_sidekiq_jobs ]
)

add_capabilities(
  category: 'discussions',
  capabilities: %w[ show hide lock unlock ]
)

add_capabilities(
  category: 'comments',
  capabilities: %w[ show hide lock unlock destroy ]
)

add_capabilities(
  category: 'spam_comments',
  capabilities: %w[ list add destroy ]
)

add_capabilities(
  category: 'email_previews',
  capabilities: %w[ list show ]
)

add_capabilities(
  category: 'stats',
  capabilities: %w[ view_web view_email view_charts make_charts ]
)

add_capabilities(
  category: 'feature_flags',
  capabilities: %w[ list edit ]
)

add_capabilities(
  category: 'settings',
  capabilities: %w[ list edit ]
)

add_capabilities(
  category: 'consent_versions',
  capabilities: %w[ list add edit destroy ]
)

add_capabilities(
  category: 'users',
  capabilities: %w[ list add edit destroy view_admin_notes ]
)

add_capabilities(
  category: 'admin_users',
  capabilities: %w[ list add edit destroy ]
)

# Feature Flags (to turn on/off areas of site functionality)
def add_feature_flag( name:, description: nil, enabled: true )
  FeatureFlag.create_or_find_by!(
    name: name,
    description: description,
    enabled: enabled,
    enabled_for_logged_in: enabled,
    enabled_for_admins: enabled
  )
end

add_feature_flag( name: 'comments',                   description: 'Enable comment features' )
add_feature_flag( name: 'comment_notifications',      description: 'Send notification emails for comments' )
add_feature_flag( name: 'akismet_for_comments',       description: 'Flag spam comments with Akismet' )
add_feature_flag( name: 'recaptcha_for_comments',     description: 'Protect comment forms with reCAPTCHA' )
add_feature_flag( name: 'recaptcha_for_registration', description: 'Protect user registration form with reCAPTCHA' )
add_feature_flag( name: 'tags',                       description: 'Enable tag features' )
add_feature_flag( name: 'upvotes',                    description: "Enable up-votes (AKA 'likes')" )
add_feature_flag( name: 'downvotes',                  description: 'Enable down-votes (requires up-votes)' )

add_feature_flag(
  name: 'user_login',
  description: 'Allow users to log in',
  enabled: false
)
add_feature_flag(
  name: 'user_registration',
  description: 'Allow new users to create an account',
  enabled: false
)

# Settings
def set_setting( name:, value: '', description: nil, level: 'site', locked: false )
  setting = Setting.create_or_find_by!( name: name.to_s )
  setting.unlock

  setting.update!( description: description ) if description.present?
  setting.update!( level: level ) unless setting.level == level

  setting_value = setting.values.create_or_find_by!( user: nil )

  setting_value.update!( value: value ) unless Setting.get( name ) == value

  setting.lock if locked
end

set_setting(
  name: :admin_ip_list,
  locked: true,
  description: 'IP addresses allowed to access admin area (comma-separated)'
)

set_setting(
  name: :all_comment_notifications_email,
  locked: true,
  description: 'Set this to an email address to receive a notification for every comment posted on the site'
)

set_setting(
  name: :allowed_to_comment,
  value: 'Anonymous',
  description: 'Lowest-ranking user-type (Anonymous/Pseudonymous/Authenticated/None) that is allowed to post comments'
)

set_setting(
  name: :anon_votes_can_change,
  value: 'false',
  description: 'Anonymous upvotes and downvotes can be changed/removed'
)

set_setting(
  name: :comment_upvotes,
  value: 'true',
  description: 'Allow upvotes on comments'
)

set_setting(
  name: :comment_downvotes,
  value: 'true',
  description: 'Allow downvotes on comments'
)

set_setting(
  name: :default_email,
  value: 'admin@example.com',
  description: 'Default email address to send from'
)

set_setting(
  name: :default_items_per_page,
  value: '10',
  description: 'Default number of items to display per page'
)

set_setting(
  name: :default_items_per_page_in_admin_area,
  value: '10',
  description: 'Default number of items to display per page in the admin area'
)

set_setting(
  name: :post_login_redirect,
  value: '/',
  level: 'admin',
  description: 'Where people are redirected after login, if no referer header'
)

set_setting(
  name: :recaptcha_comment_score,
  value: '0.6',
  level: 'admin',
  locked: true,
  description: 'Minimum score for reCAPTCHA V3 on anon/pseudonymous comments'
)

set_setting(
  name: :recaptcha_registration_score,
  value: '0.4',
  level: 'admin',
  locked: true,
  description: 'Minimum score for reCAPTCHA V3 on user registration'
)

set_setting(
  name: :site_name,
  value: 'MyShinySite',
  description: 'Default email address to send from'
)

set_setting(
  name: :tag_view,
  value: 'cloud',
  level: 'user',
  description: "('cloud' or 'list')"
)

set_setting(
  name: :theme_name,
  value: ''
)

set_setting(
  name: :track_opens,
  value: 'No',
  description: 'Track email opens'
)

set_setting(
  name: :track_opens,
  value: 'No',
  description: 'Track email link-clicks'
)

# Load seed data for any ShinyCMS plugins that are enabled
ShinyPlugin.loaded.each do |plugin|
  Rake::Task[ "#{plugin.name.underscore}:db:seed" ].invoke
end

# Let people know how to create an admin user
demo = ( Rake.application.top_level_tasks.first == 'shiny:demo:load' )
skip = User.super_admins_exist? || demo || Rails.env.test?
puts 'To generate a ShinyCMS admin user: rails shiny:admin:create' unless skip
