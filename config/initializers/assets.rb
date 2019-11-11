# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Yarn node_modules folder
Rails.application.config.assets.paths << Rails.root.join( 'node_modules' )

# Precompile stylesheets for ShinyCMS admin area, and the admin toolbar
Rails.application.config.assets.precompile += %w[
  shinycms/admin_toolbar.scss
  shinycms/admin_area.scss
]

# Assets for the main site theme (default/unstyled theme is 'shinycms')
theme = Rails.application.config.theme_name
Rails.application.config.assets.paths << Rails.root.join( theme, 'images' )
Rails.application.config.assets.precompile += %W[ #{theme}/index.css ]
