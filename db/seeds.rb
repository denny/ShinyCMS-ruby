# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This file loads some data that every ShinyCMS installation needs - feature flags, ACL capabilities, etc.
#
# It is invoked when the database is created with `rails db:setup` or reset with `rails db:reset`.
# You can also reload this data at any time using `rails db:seed`.

# Load capability data
require_relative 'seeds/capabilities'

# Load feature flag data
require_relative 'seeds/feature_flags'

# Load settings data
require_relative 'seeds/settings'

# Load seed data for any ShinyCMS plugins that are enabled
ShinyCMS::ShinyPlugin.loaded.each do |plugin|
  Rake::Task[ "#{plugin.name.underscore}:db:seed" ].invoke
end

# Load default dashboard data for Blazer
require_relative 'seeds/blazer' unless ENV['DISABLE_BLAZER'].presence&.downcase == 'true'

# If there are currently no super-admin users, show the command to create one
demo = ( Rake.application.top_level_tasks.first == 'shiny:demo:load' )
skip = User.super_admins_exist? || demo || Rails.env.test?
puts 'To generate a ShinyCMS admin user: rails shiny:admin:create' unless skip
