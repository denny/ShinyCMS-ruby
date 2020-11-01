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
add_feature_flag( name: 'akismet_for_forms',   description: 'Protect ShinyForms with Akismet'    )

# Admin capabilities

forms_cc = CapabilityCategory.find_or_create_by!( name: 'forms' )
forms_cc.capabilities.find_or_create_by!( name: 'list'    )
forms_cc.capabilities.find_or_create_by!( name: 'add'     )
forms_cc.capabilities.find_or_create_by!( name: 'edit'    )
forms_cc.capabilities.find_or_create_by!( name: 'destroy' )

# Settings

def set_setting( name:, value: '', description: nil, level: 'site', locked: false )
  setting = Setting.find_or_create_by!( name: name.to_s )
  setting.unlock

  setting.update!( description: description ) if description.present?
  setting.update!( level: level ) unless setting.level == level

  setting_value = setting.values.find_or_create_by!( user: nil )

  setting_value.update!( value: value ) unless Setting.get( name ) == value

  setting.lock if locked
end

set_setting(
  name: :recaptcha_form_score,
  value: '0.6',
  locked: true,
  description: 'Minimum score for reCAPTCHA V3 on ShinyForm submissions'
)
