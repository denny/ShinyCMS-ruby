# Be sure to restart your server when you modify this file.

require_relative 'shinycms_theme'

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Yarn node_modules folder
Rails.application.config.assets.paths << Rails.root.join( 'node_modules' )

# Add images for admin toolbar to the pipeline
base_image_path = Rails.root.join( 'app', 'assets', 'images' )
Rails.application.config.assets.paths << base_image_path.join( 'shinycms' )

# Precompile stylesheets for ShinyCMS admin area, and the admin toolbar
Rails.application.config.assets.precompile += %w[
  shinycms/admin_toolbar.scss
  shinycms/admin_area.scss
]

# Assets for the main site theme (default/unstyled theme is 'shinycms')
theme = Rails.application.config.theme_name
Rails.application.config.assets.paths << base_image_path.join( theme )
Rails.application.config.assets.precompile += %W[ #{theme}/index.css ]
