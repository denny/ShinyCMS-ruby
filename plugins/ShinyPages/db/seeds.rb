# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_pages:db:seed

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_feature_flag( name: :pages, description: "Content-managed, templated 'brochure pages' (ShinyPages plugin)" )

seeder.seed_standard_admin_capabilities( category: :pages          )
seeder.seed_standard_admin_capabilities( category: :page_sections  )
seeder.seed_standard_admin_capabilities( category: :page_templates )

seeder.seed_setting(
  name:        :default_page,
  description: 'Default top-level page (either its name or its slug)'
)

seeder.seed_setting(
  name:        :default_section,
  description: 'Default top-level section (either its name or its slug)'
)
