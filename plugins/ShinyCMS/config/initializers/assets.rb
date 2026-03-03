# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2024.11.25.1700'

# Add theme images and stylesheets to the asset load path
class ShinyCMS::ThemeAssetsSetup
  def add_all_themes_to_asset_load_path
    available_themes.each do |theme_name|
      add_theme_to_asset_load_path( theme_name )
    end
  end

  def available_themes
    Dir[ 'themes/*' ].collect { |name| name.sub( 'themes/', '' ) }
  end

  def add_theme_to_asset_load_path( theme_name )
    add_theme_images_to_asset_load_path( theme_name )
    add_theme_styles_to_asset_load_path( theme_name )
  end

  def add_theme_images_to_asset_load_path( theme_name )
    images_dir = Rails.root.join "themes/#{theme_name}/images"
    return unless Dir.exist? images_dir

    Rails.application.config.assets.paths << images_dir
  end

  def add_theme_styles_to_asset_load_path( theme_name )
    stylesheets_dir = Rails.root.join "themes/#{theme_name}/stylesheets"
    return unless Dir.exist? stylesheets_dir

    Rails.application.config.assets.paths << stylesheets_dir
    Rails.application.config.assets.precompile += %W[ #{theme_name}.css ]
  end
end

ShinyCMS::ThemeAssetsSetup.new.add_all_themes_to_asset_load_path
