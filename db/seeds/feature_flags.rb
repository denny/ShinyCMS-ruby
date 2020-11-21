# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Seed data for Feature Flags (to turn on/off areas of site functionality)

def add_feature_flag( name:, description: nil, enabled: true )
  FeatureFlag.find_or_create_by(
    name: name,
    description: description,
    enabled: enabled,
    enabled_for_logged_in: enabled,
    enabled_for_admins: enabled
  )
end

add_feature_flag( name: 'comments',                    description: 'Enable comment features' )
add_feature_flag( name: 'comment_notifications',       description: 'Send notification emails for comments' )
add_feature_flag( name: 'akismet_for_comments',        description: 'Flag spam comments with Akismet' )
add_feature_flag( name: 'recaptcha_for_comments',      description: 'Protect comment forms with reCAPTCHA' )
add_feature_flag( name: 'recaptcha_for_registrations', description: 'Protect user registration form with reCAPTCHA' )
add_feature_flag( name: 'tags',                        description: 'Enable tag features' )
add_feature_flag( name: 'upvotes',                     description: "Enable up-votes (AKA 'likes')" )
add_feature_flag( name: 'downvotes',                   description: 'Enable down-votes (requires up-votes)' )

# These two are disabled by default, to reduce the risk of brute force attacks on new/dev/demo sites
add_feature_flag( name: 'user_login',        description: 'Allow users to log in',                enabled: false )
add_feature_flag( name: 'user_registration', description: 'Allow new users to create an account', enabled: false )

# These two are disabled by default for privacy reasons
add_feature_flag( name: 'ahoy_web_tracking',   description: 'Track data about website visitors', enabled: false )
add_feature_flag( name: 'ahoy_email_tracking', description: 'Track email opens and clicks',      enabled: false )
