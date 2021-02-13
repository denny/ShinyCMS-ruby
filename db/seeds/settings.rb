# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Seed data for Settings

def set_setting( name:, value: '', description: nil, level: 'site', locked: false )
  setting = ShinyCMS::Setting.find_or_create_by!( name: name.to_s )
  setting.unlock

  setting.update!( description: description ) if description.present?
  setting.update!( level: level ) unless setting.level == level

  setting_value = setting.values.find_or_create_by!( user: nil )

  setting_value.update!( value: value ) unless ShinyCMS::Setting.get( name ) == value

  setting.lock if locked
end

set_setting(
  name:        :admin_ip_list,
  locked:      true,
  description: 'IP addresses allowed to access admin area (comma-separated)'
)

set_setting(
  name:        :akismet_drop_blatant_spam,
  value:       'true',
  description: "If Akismet flags a comment as 'blatant' spam, don't save it for moderation"
)

set_setting(
  name:        :akismet_log_blatant_spam,
  value:       'true',
  description: 'Add a log entry each time a blatant spam comment is dropped'
)

set_setting(
  name:        :all_comment_notifications_email,
  locked:      true,
  description: 'Set this to an email address to receive a notification for every comment posted on the site'
)

set_setting(
  name:        :allow_unauthenticated_comments,
  value:       'true',
  description: 'Allow comments from people who are not logged in'
)

set_setting(
  name:        :allow_anonymous_comments,
  value:       'true',
  description: '(for this to work, allow_unauthenticated_comments must also be true)'
)

set_setting(
  name:        :anon_votes_can_change,
  value:       'false',
  description: 'Anonymous upvotes and downvotes can be changed/removed'
)

set_setting(
  name:        :comment_upvotes,
  value:       'true',
  description: 'Allow upvotes on comments'
)

set_setting(
  name:        :comment_downvotes,
  value:       'true',
  description: 'Allow downvotes on comments'
)

set_setting(
  name:        :default_email,
  value:       'admin@example.com',
  description: 'Default email address to send from'
)

set_setting(
  name:        :default_items_per_page,
  value:       '10',
  description: 'Default number of items to display per page'
)

set_setting(
  name:        :default_items_per_page_in_admin_area,
  value:       '10',
  description: 'Default number of items to display per page in the admin area'
)

set_setting(
  name:        :post_login_redirect,
  value:       '/',
  level:       'admin',
  description: 'Where people are redirected after login, if no referer header'
)

set_setting(
  name:        :recaptcha_score_default,
  value:       '0.5',
  locked:      true,
  description: 'Default minimum score for reCAPTCHA V3'
)

set_setting(
  name:        :recaptcha_score_for_comments,
  value:       '0.6',
  locked:      true,
  description: 'Minimum score for reCAPTCHA V3 on anon/pseudonymous comments'
)

set_setting(
  name:        :recaptcha_score_for_registrations,
  value:       '0.4',
  locked:      true,
  description: 'Minimum score for reCAPTCHA V3 on user registration'
)

set_setting(
  name:        :site_name,
  value:       'MyShinySite',
  description: 'The name of the content site'
)

set_setting(
  name:        :tag_view,
  value:       'cloud',
  level:       'user',
  description: "('cloud' or 'list')"
)

set_setting(
  name:  :theme_name,
  value: ''
)

set_setting(
  name:        :track_opens,
  value:       'No',
  description: 'Track email opens'
)

set_setting(
  name:        :track_clicks,
  value:       'No',
  description: 'Track email link-clicks'
)
