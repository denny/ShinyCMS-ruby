# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_access:db:seed

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_feature_flag( name: :access, description: 'Access control features on main site' )

seeder.seed_standard_admin_capabilities( category: :access_groups )

category = seeder.seed_standard_admin_capabilities( category: :access_group_memberships )
category.capabilities.destroy_fully!( name: 'edit' )
