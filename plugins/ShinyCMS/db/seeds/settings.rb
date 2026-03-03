# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Seed data for Settings

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_setting(
  name:        :allowed_ips,
  locked:      true,
  description: 'IP addresses allowed to access admin area (comma-separated)'
)

seeder.seed_setting(
  name:        :akismet_drop_blatant_spam,
  value:       'true',
  description: "If Akismet flags a comment as 'blatant' spam, don't save it for moderation"
)

seeder.seed_setting(
  name:        :akismet_log_blatant_spam,
  value:       'true',
  description: 'Add a log entry each time a blatant spam comment is dropped'
)

seeder.seed_setting(
  name:        :all_comment_notifications_email,
  locked:      true,
  description: 'Set this to an email address to receive a notification for every comment posted on the site'
)

seeder.seed_setting(
  name:        :allow_unauthenticated_comments,
  value:       'true',
  description: 'Allow comments from people who are not logged in'
)

seeder.seed_setting(
  name:        :allow_anonymous_comments,
  value:       'true',
  description: '(for this to work, allow_unauthenticated_comments must also be true)'
)

seeder.seed_setting(
  name:        :anon_votes_can_change,
  value:       'false',
  description: 'Anonymous upvotes and downvotes can be changed/removed'
)

seeder.seed_setting(
  name:        :comment_upvotes,
  value:       'true',
  description: 'Allow upvotes on comments'
)

seeder.seed_setting(
  name:        :comment_downvotes,
  value:       'true',
  description: 'Allow downvotes on comments'
)

seeder.seed_setting(
  name:        :default_email,
  value:       'admin@example.com',
  description: 'Default email address to send from'
)

seeder.seed_setting(
  name:        :default_items_per_page,
  value:       '10',
  description: 'Default number of items to display per page'
)

seeder.seed_setting(
  name:        :default_items_per_page_in_admin_area,
  value:       '10',
  description: 'Default number of items to display per page in the admin area'
)

seeder.seed_setting(
  name:        :post_login_redirect,
  value:       '/',
  level:       'admin',
  description: 'Where people are redirected after login, if no referer header'
)

seeder.seed_setting(
  name:        :recaptcha_score_default,
  value:       '0.5',
  locked:      true,
  description: 'Default minimum score for reCAPTCHA V3'
)

seeder.seed_setting(
  name:        :recaptcha_score_for_comments,
  value:       '0.6',
  locked:      true,
  description: 'Minimum score for reCAPTCHA V3 on anon/pseudonymous comments'
)

seeder.seed_setting(
  name:        :recaptcha_score_for_registrations,
  value:       '0.4',
  locked:      true,
  description: 'Minimum score for reCAPTCHA V3 on user registration'
)

seeder.seed_setting(
  name:        :site_name,
  value:       'MyShinySite',
  description: 'The name of the content site'
)

seeder.seed_setting(
  name:        :tag_view,
  value:       'cloud',
  level:       'user',
  description: "('cloud' or 'list')"
)

seeder.seed_setting(
  name:  :theme_name,
  value: ''
)

seeder.seed_setting(
  name:        :track_opens,
  value:       'No',
  description: 'Track email opens'
)

seeder.seed_setting(
  name:        :track_clicks,
  value:       'No',
  description: 'Track email link-clicks'
)
