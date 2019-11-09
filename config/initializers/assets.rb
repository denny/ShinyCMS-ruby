# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Yarn node_modules folder
Rails.application.config.assets.paths << Rails.root.join( 'node_modules' )
# ShinyCMS default layout images (including admin toolbar)
Rails.application.config.assets.paths << Rails.root.join( 'shinycms', 'images' )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w[
  shinycms/main_site.css
  shinycms/admin_toolbar.scss
  shinycms/admin_area.scss
]

# Look for a non-default theme_name, if one is set then load its assets
theme = Rails.application.config.theme_name
unless theme == 'default'
  Rails.application.config.assets.paths << Rails.root.join( theme, 'images' )
  Rails.application.config.assets.precompile += %W[ #{theme}/index.css ]
end
