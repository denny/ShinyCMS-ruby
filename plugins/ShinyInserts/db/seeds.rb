# frozen_string_literal: true

# ShinyInserts plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_inserts:db:seed

# Add admin capabilities for pundit authorisation
category = CapabilityCategory.create_or_find_by!( name: 'inserts' )
category.capabilities.create_or_find_by!( name: 'list'    )
category.capabilities.create_or_find_by!( name: 'add'     )
category.capabilities.create_or_find_by!( name: 'edit'    )
category.capabilities.create_or_find_by!( name: 'destroy' )

# Add an insert set; used purely as a convenient handle for updating the elements en masse
ShinyInserts::Set.create! if ShinyInserts::Set.first.blank?
