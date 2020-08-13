# frozen_string_literal: true

# This file contains any data which is either necessary to get ShinyCMS running,
# or which might provide useful hints for configuration after that.
#
# It is used to populate the databse when you create it with `rails db:setup`
# You can also load it (and reload it) at any time using `rails db:seed`

# Capabilities (for user authorisation, via Pundit)
general_cc    = seed CapabilityCategory, { name: 'general'        }
blogs_cc      = seed CapabilityCategory, { name: 'blogs'          }
blog_posts_cc = seed CapabilityCategory, { name: 'blog_posts'     }
discussion_cc = seed CapabilityCategory, { name: 'discussions'    }
comments_cc   = seed CapabilityCategory, { name: 'comments'       }
spam_cc       = seed CapabilityCategory, { name: 'spam_comments'  }
emails_cc     = seed CapabilityCategory, { name: 'email_previews' }
features_cc   = seed CapabilityCategory, { name: 'feature_flags'  }
inserts_cc    = seed CapabilityCategory, { name: 'inserts'        }
pages_cc      = seed CapabilityCategory, { name: 'pages'          }
sections_cc   = seed CapabilityCategory, { name: 'page_sections'  }
templates_cc  = seed CapabilityCategory, { name: 'page_templates' }
stats_cc      = seed CapabilityCategory, { name: 'stats'          }
settings_cc   = seed CapabilityCategory, { name: 'settings'       }
users_cc      = seed CapabilityCategory, { name: 'users'          }
admins_cc     = seed CapabilityCategory, { name: 'admin_users'    }
# General
seed Capability, { name: 'view_admin_area'      }, { category: general_cc }
seed Capability, { name: 'view_admin_dashboard' }, { category: general_cc }
seed Capability, { name: 'view_admin_toolbar'   }, { category: general_cc }
# Blogs
seed Capability, { name: 'list',    category: blogs_cc }
seed Capability, { name: 'add',     category: blogs_cc }
seed Capability, { name: 'edit',    category: blogs_cc }
seed Capability, { name: 'destroy', category: blogs_cc }
# Blog Posts
seed Capability, { name: 'list',          category: blog_posts_cc }
seed Capability, { name: 'add',           category: blog_posts_cc }
seed Capability, { name: 'edit',          category: blog_posts_cc }
seed Capability, { name: 'destroy',       category: blog_posts_cc }
seed Capability, { name: 'change_author', category: blog_posts_cc }
# Discussions
seed Capability, { name: 'show',    category: discussion_cc }
seed Capability, { name: 'hide',    category: discussion_cc }
seed Capability, { name: 'lock',    category: discussion_cc }
seed Capability, { name: 'unlock',  category: discussion_cc }
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
# Email Previews
seed Capability, { name: 'list',    category: emails_cc }
seed Capability, { name: 'show',    category: emails_cc }
# Feature Flags
seed Capability, { name: 'list',    category: features_cc }
seed Capability, { name: 'edit',    category: features_cc }
# Inserts
seed Capability, { name: 'list',    category: inserts_cc }
seed Capability, { name: 'add',     category: inserts_cc }
seed Capability, { name: 'edit',    category: inserts_cc }
seed Capability, { name: 'destroy', category: inserts_cc }
# Pages
seed Capability, { name: 'list',    category: pages_cc }
seed Capability, { name: 'add',     category: pages_cc }
seed Capability, { name: 'edit',    category: pages_cc }
seed Capability, { name: 'destroy', category: pages_cc }
# Page Sections
seed Capability, { name: 'list',    category: sections_cc }
seed Capability, { name: 'add',     category: sections_cc }
seed Capability, { name: 'edit',    category: sections_cc }
seed Capability, { name: 'destroy', category: sections_cc }
# Page Templates
seed Capability, { name: 'list',    category: templates_cc }
seed Capability, { name: 'add',     category: templates_cc }
seed Capability, { name: 'edit',    category: templates_cc }
seed Capability, { name: 'destroy', category: templates_cc }
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
seed FeatureFlag, { name: 'blogs' }, {
  description: 'Turn this on if you want a blog on your site',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'blog_votes' }, {
  description: 'Enable votes (likes) on blog posts',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'blog_downvotes' }, {
  description: 'Enable down-votes (dislikes) on blog posts',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
}
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

# InsertSet, to tie any insert elements together
InsertSet.create! if InsertSet.first.blank?

# Settings
setting = seed Setting, { name: 'admin_ip_list' }, {
  description: 'IP addresses allowed to access admin area (comma-separated)',
  level: 'site',
  locked: true
}
setting.values.create_or_find_by!( value: '' )

setting = seed Setting, { name: 'all_comment_notifications_email' }, {
  description: 'Set this to an email address to receive a notification for every comment posted on the site',
  level: 'site',
  locked: true
}
setting.values.create_or_find_by!( value: '' )

setting = seed Setting, { name: 'allowed_to_comment' }, {
  description: 'Lowest-ranking user-type (Anonymous/Pseudonymous/Authenticated/None) that is allowed to post comments',
  level: 'site',
  locked: false
}
setting.values.create_or_find_by!( value: 'Anonymous' )
setting.update( locked: true )

setting = seed Setting, { name: 'default_email' }, {
  description: 'Default email address to send from',
  level: 'site',
  locked: false
}
setting.values.create_or_find_by!( value: 'admin@example.com' )

setting = seed Setting, { name: 'default_page' }, {
  description: 'Default top-level page (either its name or its slug)',
  level: 'site',
  locked: false
}
setting.values.create_or_find_by!( value: '' )

setting = seed Setting, { name: 'default_section' }, {
  description: 'Default top-level section (either its name or its slug)',
  level: 'site',
  locked: false
}
setting.values.create_or_find_by!( value: '' )

setting = seed Setting, { name: 'post_login_redirect' }, {
  description: 'Where people are redirected after login, if no referer header',
  level: 'admin',
  locked: false
}
setting.values.create_or_find_by!( value: '/' )

setting = seed Setting, { name: 'recaptcha_comment_score' }, {
  description: 'Minimum score for reCAPTCHA V3 on anon/pseudonymous comments',
  level: 'admin',
  locked: true
}
setting.values.create_or_find_by!( value: '0.6' )

setting = seed Setting, { name: 'recaptcha_registration_score' }, {
  description: 'Minimum score for reCAPTCHA V3 on user registration',
  level: 'admin',
  locked: true
}
setting.values.create_or_find_by!( value: '0.4' )

setting = seed Setting, { name: 'tag_view' }, {
  description: "('cloud' or 'list')",
  level: 'user',
  locked: false
}
setting.values.create_or_find_by!( value: 'cloud' )

setting = seed Setting, { name: 'theme_name' }, {
  description: '',
  level: 'site',
  locked: false
}
setting.values.create_or_find_by!( value: '' )

setting = seed Setting, { name: 'track_opens' }, {
  description: 'Track email opens',
  level: 'site',
  locked: true
}
setting.values.create_or_find_by!( value: 'No' )

setting = seed Setting, { name: 'track_clicks' }, {
  description: 'Track email link-clicks',
  level: 'site',
  locked: true
}
setting.values.create_or_find_by!( value: 'No' )

# Load seed data for any ShinyCMS plugins that are enabled
Plugin.loaded.each do |plugin_name|
  Rake::Task[ "#{plugin_name.underscore}:db:seed" ].invoke
end

# Let people know how to create an admin user
demo = ( Rake.application.top_level_tasks.first == 'shiny:demo:load' )
skip = User.super_admins_exist? || demo || Rails.env.test?
puts 'To generate a ShinyCMS admin user: rails shiny:admin:create' unless skip
