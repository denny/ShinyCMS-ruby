# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_profiles:db:seed

# Add feature flag
flag = FeatureFlag.find_or_create_by!( name: 'profile_pages' )
flag.update!(
  description: 'Enable user profile pages, provided by ShinyProfiles plugin',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)
