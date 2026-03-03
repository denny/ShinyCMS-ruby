# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Seed data for Feature Flags (to turn on/off areas of site functionality)

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_feature_flag( name: 'send_emails', description: 'Allow ShinyCMS to send outgoing emails' )

seeder.seed_feature_flag( name: 'comments',               description: 'Enable comment features' )
seeder.seed_feature_flag( name: 'comment_notifications',  description: 'Send notification emails for comments' )
seeder.seed_feature_flag( name: 'akismet_for_comments',   description: 'Flag spam comments with Akismet' )
seeder.seed_feature_flag( name: 'recaptcha_for_comments', description: 'Protect comment forms with reCAPTCHA' )

seeder.seed_feature_flag( name: 'recaptcha_for_registrations', description: 'Protect registration form with reCAPTCHA' )

seeder.seed_feature_flag( name: 'tags',      description: 'Enable tag features' )

seeder.seed_feature_flag( name: 'upvotes',   description: "Enable up-votes (AKA 'likes')" )
seeder.seed_feature_flag( name: 'downvotes', description: 'Enable down-votes (requires up-votes)' )

# These two are disabled by default, to reduce the risk of brute force attacks on new/dev/demo sites
seeder.seed_feature_flag( name: 'user_login',        description: 'Allow users to log in',              enabled: false )
seeder.seed_feature_flag( name: 'user_registration', description: 'Allow new users to create accounts', enabled: false )

# These two are disabled by default for privacy reasons
seeder.seed_feature_flag( name: 'ahoy_web_tracking',   description: 'Track data about website traffic', enabled: false )
seeder.seed_feature_flag( name: 'ahoy_email_tracking', description: 'Track email opens and clicks',     enabled: false )
