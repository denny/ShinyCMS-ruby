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
general_cc    = seed CapabilityCategory, { name: 'general'          }
discussion_cc = seed CapabilityCategory, { name: 'discussions'      }
comments_cc   = seed CapabilityCategory, { name: 'comments'         }
spam_cc       = seed CapabilityCategory, { name: 'spam_comments'    }
consent_cc    = seed CapabilityCategory, { name: 'consent_versions' }
emails_cc     = seed CapabilityCategory, { name: 'email_previews'   }
features_cc   = seed CapabilityCategory, { name: 'feature_flags'    }
stats_cc      = seed CapabilityCategory, { name: 'stats'            }
settings_cc   = seed CapabilityCategory, { name: 'settings'         }
users_cc      = seed CapabilityCategory, { name: 'users'            }
admins_cc     = seed CapabilityCategory, { name: 'admin_users'      }
# General
seed Capability, { name: 'view_admin_area'     }, { category: general_cc }
seed Capability, { name: 'view_admin_toolbar'  }, { category: general_cc }
seed Capability, { name: 'manage_sidekiq_jobs' }, { category: general_cc }
# Consent Versions
seed Capability, { name: 'list',    category: consent_cc }
seed Capability, { name: 'add',     category: consent_cc }
seed Capability, { name: 'edit',    category: consent_cc }
seed Capability, { name: 'destroy', category: consent_cc }
# Comments
seed Capability, { name: 'show',    category: comments_cc }
seed Capability, { name: 'hide',    category: comments_cc }
seed Capability, { name: 'lock',    category: comments_cc }
seed Capability, { name: 'unlock',  category: comments_cc }
seed Capability, { name: 'destroy', category: comments_cc }
# Spam Comments
seed Capability, { name: 'list',    category: spam_cc }
seed Capability, { name: 'add',     category: spam_cc }
seed Capability, { name: 'destroy', category: spam_cc }
# Discussions
seed Capability, { name: 'show',    category: discussion_cc }
seed Capability, { name: 'hide',    category: discussion_cc }
seed Capability, { name: 'lock',    category: discussion_cc }
seed Capability, { name: 'unlock',  category: discussion_cc }
# Email Previews
seed Capability, { name: 'list',    category: emails_cc }
seed Capability, { name: 'show',    category: emails_cc }
# Feature Flags
seed Capability, { name: 'list',    category: features_cc }
seed Capability, { name: 'edit',    category: features_cc }
# Stats
seed Capability, { name: 'view_web',    category: stats_cc }
seed Capability, { name: 'view_email',  category: stats_cc }
seed Capability, { name: 'view_charts', category: stats_cc }
seed Capability, { name: 'make_charts', category: stats_cc }
# Site Settings
seed Capability, { name: 'list',    category: settings_cc }
seed Capability, { name: 'edit',    category: settings_cc }
# Users
seed Capability, { name: 'list',    category: users_cc }
seed Capability, { name: 'add',     category: users_cc }
seed Capability, { name: 'edit',    category: users_cc }
seed Capability, { name: 'destroy', category: users_cc }
seed Capability, { name: 'view_admin_notes', category: users_cc }
# Admin Users
seed Capability, { name: 'list',    category: admins_cc }
seed Capability, { name: 'add',     category: admins_cc }
seed Capability, { name: 'edit',    category: admins_cc }
seed Capability, { name: 'destroy', category: admins_cc }

# Feature Flags (to turn on/off areas of site functionality)
seed FeatureFlag, { name: 'comments' }, {
  description: 'Enable comment and discussion features site-wide',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'comment_votes' }, {
  description: 'Enable votes on comments',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'comment_downvotes' }, {
  description: 'Enable down-votes on comments',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'comment_notifications' }, {
  description: 'Send notification emails to people who get comments',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'akismet_on_comments' }, {
  description: 'Detect spam comments with Akismet',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'recaptcha_on_comment_form' }, {
  description: 'Protect comment forms with reCAPTCHA',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'recaptcha_on_registration_form' }, {
  description: 'Protect user registration form with reCAPTCHA',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'tags' }, {
  description: 'Turn on site-wide tag features',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'user_login' }, {
  description: 'Allow users to log in',
  enabled: false,
  enabled_for_logged_in: false,
  enabled_for_admins: false
}
seed FeatureFlag, { name: 'user_registration' }, {
  description: 'Allow new users to create an account',
  enabled: false,
  enabled_for_logged_in: false,
  enabled_for_admins: false
}

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
  name: :default_email,
  value: 'admin@example.com',
  description: 'Default email address to send from'
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
Plugin.loaded.each do |plugin|
  Rake::Task[ "#{plugin.name.underscore}:db:seed" ].invoke
end

# Let people know how to create an admin user
demo = ( Rake.application.top_level_tasks.first == 'shiny:demo:load' )
skip = User.super_admins_exist? || demo || Rails.env.test?
puts 'To generate a ShinyCMS admin user: rails shiny:admin:create' unless skip
