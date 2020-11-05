# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2020.01.04.1510'

# Add additional assets to the asset load path.
# Yarn node_modules folder
Rails.application.config.assets.paths << Rails.root.join( 'node_modules' )
