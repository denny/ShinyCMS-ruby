# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_newsletters:db:seed

# Feature flag

flag = FeatureFlag.find_or_create_by!( name: 'newsletters' )
flag.update!(
  description: 'Enable newsletter features (provided by ShinyNewsletters plugin)',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)

# Admin capabilities

templates_cc = CapabilityCategory.find_or_create_by!( name: 'newsletter_templates' )
editions_cc  = CapabilityCategory.find_or_create_by!( name: 'newsletter_editions'  )
sends_cc     = CapabilityCategory.find_or_create_by!( name: 'newsletter_sends'     )

editions_cc.capabilities.find_or_create_by!( name: 'list'    )
editions_cc.capabilities.find_or_create_by!( name: 'add'     )
editions_cc.capabilities.find_or_create_by!( name: 'edit'    )
editions_cc.capabilities.find_or_create_by!( name: 'destroy' )

templates_cc.capabilities.find_or_create_by!( name: 'list'    )
templates_cc.capabilities.find_or_create_by!( name: 'add'     )
templates_cc.capabilities.find_or_create_by!( name: 'edit'    )
templates_cc.capabilities.find_or_create_by!( name: 'destroy' )

sends_cc.capabilities.find_or_create_by!( name: 'list'    )
sends_cc.capabilities.find_or_create_by!( name: 'add'     )
sends_cc.capabilities.find_or_create_by!( name: 'edit'    )
sends_cc.capabilities.find_or_create_by!( name: 'destroy' )
