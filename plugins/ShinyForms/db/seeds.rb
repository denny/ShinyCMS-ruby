# frozen_string_literal: true

# ============================================================================
# Project:   ShinyForms plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyProfiles/db/seeds.rb
# Purpose:   Seed data (feature flags and admin capabilities)
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

# You can load or reload this data using the following rake task:
# rails shiny_forms:db:seed

# Add feature flag
forms_flag = FeatureFlag.find_or_create_by!( name: 'shiny_forms' )
forms_flag.update!(
  description: 'Enable generic form handlers from ShinyForms plugin',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)
form_emails_flag = FeatureFlag.find_or_create_by!( name: 'shiny_forms_emails' )
form_emails_flag.update!(
  description: 'Allow form handlers to send emails',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)

# Add admin capabilities
forms_cc = CapabilityCategory.find_or_create_by!( name: 'shiny_forms_forms' )
forms_cc.capabilities.find_or_create_by!( name: 'list'    )
forms_cc.capabilities.find_or_create_by!( name: 'add'     )
forms_cc.capabilities.find_or_create_by!( name: 'edit'    )
forms_cc.capabilities.find_or_create_by!( name: 'destroy' )
