# frozen_string_literal: true

# ShinySearch plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_search:db:seed

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_feature_flag( name: :search, description: 'Search features for the main site (ShinySearch plugin)' )

seeder.seed_setting(
  name:        :default_search_backend,
  description: 'Default back-end engine for search feature (pg or algolia)',
  value:       'pg'
)

seeder.seed_setting(
  name:        :search_enabled_algolia,
  description: 'Is the Algolia search backend enabled',
  value:       'true'
)

seeder.seed_setting(
  name:        :search_enabled_postgres,
  description: 'Is the Postgres search backend enabled',
  value:       'true'
)
