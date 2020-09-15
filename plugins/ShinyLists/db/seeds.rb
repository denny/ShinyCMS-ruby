# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_lists:db:seed

# Feature flag

flag = FeatureFlag.find_or_create_by!( name: 'mailing_lists' )
flag.update!(
  description: 'Enable mailing list features (provided by ShinyLists plugin)',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)

# Admin capabilities

lists_cc = CapabilityCategory.find_or_create_by!( name: 'mailing_lists' )
subscriptions_cc = CapabilityCategory.find_or_create_by!( name: 'mailing_list_subscriptions' )

lists_cc.capabilities.find_or_create_by!( name: 'list'    )
lists_cc.capabilities.find_or_create_by!( name: 'add'     )
lists_cc.capabilities.find_or_create_by!( name: 'edit'    )
lists_cc.capabilities.find_or_create_by!( name: 'destroy' )

subscriptions_cc.capabilities.find_or_create_by!( name: 'list'   )
subscriptions_cc.capabilities.find_or_create_by!( name: 'add'    )
subscriptions_cc.capabilities.find_or_create_by!( name: 'remove' )

# Consent version used when a list admin manually subscribes somebody

ConsentVersion.find_or_create_by!(
  name: 'Subscribed by list admin',
  slug: 'shiny-lists-admin-subscribe',
  display_text: 'Manually subscribing people to lists might make it difficult to prove their consent. Are you sure?',
  admin_notes: 'This is the consent version recorded when an admin manually subscribes somebody to a mailing list.'
)
