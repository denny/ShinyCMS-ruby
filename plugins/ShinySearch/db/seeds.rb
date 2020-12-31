# frozen_string_literal: true

# ShinySearch plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_search:db:seed

# Add feature flag
flag = FeatureFlag.find_or_create_by!( name: 'search' )
flag.update!(
  description:           'Turn on search features',
  enabled:               true,
  enabled_for_logged_in: true,
  enabled_for_admins:    true
)

# Add setting for default search backend
setting = Setting.find_or_create_by!( name: 'default_search_backend' )
setting.update!(
  description: 'Default back-end engine for search feature (pg or algolia)',
  level:       'site',
  locked:      false
)
setting.values.find_or_create_by!( value: 'pg' )

setting = Setting.find_or_create_by!( name: 'search_enabled_algolia' )
setting.update!(
  description: 'Is the Algolia search backend enabled',
  level:       'site',
  locked:      false
)
setting.values.find_or_create_by!( value: 'true' )

setting = Setting.find_or_create_by!( name: 'search_enabled_postgres' )
setting.update!(
  description: 'Is the Postgres search backend enabled',
  level:       'site',
  locked:      false
)
setting.values.find_or_create_by!( value: 'true' )
