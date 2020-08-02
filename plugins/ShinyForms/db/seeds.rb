# frozen_string_literal: true

# This file contains supporting data required by the ShinyForms plugin for ShinyCMS
# (specifically, a feature flag, and the admin user capabilities for authorisation)
#
# You can load or reload this data using the following rake task:
# rails shiny_forms:install:data

# Add feature flag
forms_flag = FeatureFlag.find_or_create_by!( name: 'forms' )
forms_flag.update!(
  description: 'Enable generic form handlers from ShinyForms plugin',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)

# Add admin capabilities
forms_cc = CapabilityCategory.find_or_create_by!( name: 'forms' )
forms_cc.capabilities.find_or_create_by!( name: 'list'    )
forms_cc.capabilities.find_or_create_by!( name: 'add'     )
forms_cc.capabilities.find_or_create_by!( name: 'edit'    )
forms_cc.capabilities.find_or_create_by!( name: 'destroy' )
