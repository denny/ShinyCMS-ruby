# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_access:db:seed

# Feature flag

flag = ShinyCMS::FeatureFlag.find_or_create_by!( name: 'access' )
flag.update!(
  description:           'Enable access control features (provided by ShinyAccess plugin)',
  enabled:               true,
  enabled_for_logged_in: true,
  enabled_for_admins:    true
)

# Admin capabilities

group_cc = ShinyCMS::CapabilityCategory.find_or_create_by!( name: 'access_groups' )
membership_cc = ShinyCMS::CapabilityCategory.find_or_create_by!( name: 'access_group_memberships' )

group_cc.capabilities.find_or_create_by!( name: 'list'    )
group_cc.capabilities.find_or_create_by!( name: 'add'     )
group_cc.capabilities.find_or_create_by!( name: 'edit'    )
group_cc.capabilities.find_or_create_by!( name: 'destroy' )

membership_cc.capabilities.find_or_create_by!( name: 'list'    )
membership_cc.capabilities.find_or_create_by!( name: 'add'     )
membership_cc.capabilities.find_or_create_by!( name: 'destroy' )
