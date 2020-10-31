# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_pages:db:seed

# Feature flag

flag = FeatureFlag.find_or_create_by!( name: 'pages' )
flag.update!(
  description: "Enable 'brochure pages', provided by ShinyPages plugin",
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)

# Admin capabilities

pages_cc = CapabilityCategory.find_or_create_by!( name: 'pages' )
sections_cc = CapabilityCategory.find_or_create_by!( name: 'page_sections' )
templates_cc = CapabilityCategory.find_or_create_by!( name: 'page_templates' )

pages_cc.capabilities.find_or_create_by!( name: 'list'    )
pages_cc.capabilities.find_or_create_by!( name: 'add'     )
pages_cc.capabilities.find_or_create_by!( name: 'edit'    )
pages_cc.capabilities.find_or_create_by!( name: 'destroy' )

sections_cc.capabilities.find_or_create_by!( name: 'list'    )
sections_cc.capabilities.find_or_create_by!( name: 'add'     )
sections_cc.capabilities.find_or_create_by!( name: 'edit'    )
sections_cc.capabilities.find_or_create_by!( name: 'destroy' )

templates_cc.capabilities.find_or_create_by!( name: 'list'    )
templates_cc.capabilities.find_or_create_by!( name: 'add'     )
templates_cc.capabilities.find_or_create_by!( name: 'edit'    )
templates_cc.capabilities.find_or_create_by!( name: 'destroy' )

# Site settings

setting1 = Setting.find_or_create_by!( name: 'default_page' )
setting1.update!(
  description: 'Default top-level page (either its name or its slug)',
  level: 'site',
  locked: false
)
setting1.values.find_or_create_by!( value: '' )

setting2 = Setting.find_or_create_by!( name: 'default_section' )
setting2.update!(
  description: 'Default top-level section (either its name or its slug)',
  level: 'site',
  locked: false
)
setting2.values.find_or_create_by!( value: '' )
