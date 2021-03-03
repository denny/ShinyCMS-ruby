# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# To copy and run the database migrations for ShinySEO:
#   rails shiny_seo:install:migrations
#   rails db:migrate
#
# To install supporting data for ShinySEO (admin capabilities and feature flags):
#   rails shiny_seo:db:seed
#
# These two tasks can be run in either order.

# You must copy the sitemap config hook file into your main app's
# config directory if you want to use the SEO sitemap features:
#   rails shiny_seo:install:config

namespace :shiny_seo do
  namespace :db do
    desc 'ShinyCMS: load supporting data for ShinySEO plugin'
    task seed: %i[ environment dotenv ] do
      # :nocov:
      ShinySEO::Engine.load_seed
      # :nocov:
    end
  end

  namespace :install do
    desc 'ShinyCMS: copy sitemap config hook file to your main_app'
    task config: %i[ environment dotenv ] do
      # :nocov:
      main_app_config_file = Rails.root.join 'config/sitemap.rb'

      if File.exist? main_app_config_file
        puts 'File already exists at /config/sitemap.rb'
        exit
      end

      config_hook_file = ShinySEO::Engine.root.join 'config/main_app_config_sitemap.rb'

      FileUtils.cp config_hook_file, main_app_config_file

      puts 'Sitemap config hook file installed at /config/sitemap.rb'
      # :nocov:
    end
  end
end
