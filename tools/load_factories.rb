# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Utility script to load factories and faker libs when working in console

# To use FactoryBot in the rails console:
# 1. Run `require_relative 'tools/load_factories'`
# 2. Use FactoryBot as normal, e.g. `user = create(:user)`

require 'factory_bot'
require 'faker'

factory_dirs = Rails.root.glob( 'plugins/Shiny*/spec/factories' )

FactoryBot.definition_file_paths.concat factory_dirs
FactoryBot.find_definitions

# This include makes factory methods global so "FactoryBot." namespace is not needed,
# meaning you can call `create(:user)` instead of `FactoryBot.create(:user)`:
include FactoryBot::Syntax::Methods
