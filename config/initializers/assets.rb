# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2020.01.04.1510'

# Add node_modules directory to the asset load path.
Rails.application.config.assets.paths << Rails.root.join( 'node_modules' )

# Add theme images and stylesheets to the asset load path
def add_all_themes_to_asset_load_path
  available_themes.each do |theme_name|
    add_theme_to_asset_load_path( theme_name )
  end
end

def available_themes
  Dir[ 'themes/*' ].sort.collect { |name| name.sub( 'themes/', '' ) }
end

def add_theme_to_asset_load_path( theme_name )
  stylesheets_dir = Rails.root.join "themes/#{theme_name}/stylesheets"
  images_dir      = Rails.root.join "themes/#{theme_name}/images"

  Rails.application.config.assets.paths << stylesheets_dir if Dir.exist? stylesheets_dir
  Rails.application.config.assets.paths << images_dir      if Dir.exist? images_dir
end

add_all_themes_to_asset_load_path
