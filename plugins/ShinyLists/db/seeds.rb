# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_lists:db:seed

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_feature_flag( name: :mailing_lists, description: 'Enable mailing lists (ShinyLists plugin)' )

seeder.seed_standard_admin_capabilities( category: :mailing_lists )

category = seeder.seed_standard_admin_capabilities( category: :mailing_list_subscriptions )
category.capabilities.destroy_fully!( name: 'edit' )

# Consent version used when a list admin manually subscribes somebody
seeder.seed_consent_version(
  name:         'Subscribed by list admin',
  slug:         'shiny-lists-admin-subscribe',
  display_text: 'Manually subscribing people to lists might make it difficult to prove their consent. Are you sure?',
  admin_notes:  'This is the consent version recorded when an admin manually subscribes somebody to a mailing list.'
)
