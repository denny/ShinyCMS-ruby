# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_newsletters:db:seed

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_feature_flag( name: :newsletters, description: 'Enable ShinyNewsletters plugin'  )

seeder.seed_standard_admin_capabilities( category: :newsletter_editions  )
seeder.seed_standard_admin_capabilities( category: :newsletter_templates )
seeder.seed_standard_admin_capabilities( category: :newsletter_sends     )
