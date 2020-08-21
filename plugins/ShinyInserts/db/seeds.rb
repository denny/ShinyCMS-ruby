# frozen_string_literal: true

# ============================================================================
# Project:   ShinyInserts plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyInserts/db/seeds.rb
# Purpose:   Seed data (admin capabilities and default InsertSet)
#
# Copyright 2009-2020 Denny de la Haye (https://denny.me)
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

# You can load or reload this data using the following rake task:
# rails shiny_inserts:db:seed

# Add admin capabilities for pundit authorisation
category = CapabilityCategory.find_or_create_by!( name: 'inserts' )
category.capabilities.find_or_create_by!( name: 'list'    )
category.capabilities.find_or_create_by!( name: 'add'     )
category.capabilities.find_or_create_by!( name: 'edit'    )
category.capabilities.find_or_create_by!( name: 'destroy' )

# Add an insert set; used purely as a convenient handle for updating the elements en masse
ShinyInserts::Set.create! if ShinyInserts::Set.first.blank?
