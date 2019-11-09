# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w[
  shinycms/main_site.css

  shinycms/admin_area.scss

  ckeditor/config.js
]

# Halcyonic theme for main site
# if ENV['SHINYCMS_THEME'] == 'halcyonic'
Rails.application.config.assets.precompile += %w[
  halcyonic/main.css
  halcyonic/shinycms.css
  halcyonic/jquery.min.js
  halcyonic/breakpoints.min.js
  halcyonic/browser.min.js
  halcyonic/util.js
  halcyonic/main.js
]
# end
