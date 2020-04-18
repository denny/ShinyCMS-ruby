# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2020.01.04.1510'

# Add additional assets to the asset load path.
# Yarn node_modules folder
Rails.application.config.assets.paths << Rails.root.join( 'node_modules' )
