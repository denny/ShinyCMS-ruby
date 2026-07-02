# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_forms:db:seed

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_feature_flag( name: :shiny_forms,         description: 'Enable generic form handlers (ShinyForms plugin)' )
seeder.seed_feature_flag( name: :shiny_forms_emails,  description: 'Allow form handlers to send emails' )
seeder.seed_feature_flag( name: :recaptcha_for_forms, description: 'Protect ShinyForms with reCAPTCHA'  )
seeder.seed_feature_flag( name: :akismet_for_forms,   description: 'Protect ShinyForms with Akismet'    )

seeder.seed_setting(
  name:        :recaptcha_score_for_forms,
  description: 'Minimum score for reCAPTCHA V3 on ShinyForm submissions',
  value:       '0.6',
  locked:      true
)

seeder.seed_standard_admin_capabilities( category: :forms )
