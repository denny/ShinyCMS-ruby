# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_forms:db:seed

# Feature flags

def add_feature_flag( name:, description: nil, enabled: true )
  FeatureFlag.find_or_create_by(
    name: name,
    description: description,
    enabled: enabled,
    enabled_for_logged_in: enabled,
    enabled_for_admins: enabled
  )
end

add_feature_flag( name: 'shiny_forms',         description: 'Enable generic form handlers, from ShinyForms plugin' )
add_feature_flag( name: 'shiny_forms_emails',  description: 'Allow form handlers to send emails' )
add_feature_flag( name: 'recaptcha_for_forms', description: 'Protect ShinyForms with reCAPTCHA'  )

# Admin capabilities

forms_cc = CapabilityCategory.find_or_create_by!( name: 'forms' )
forms_cc.capabilities.find_or_create_by!( name: 'list'    )
forms_cc.capabilities.find_or_create_by!( name: 'add'     )
forms_cc.capabilities.find_or_create_by!( name: 'edit'    )
forms_cc.capabilities.find_or_create_by!( name: 'destroy' )
