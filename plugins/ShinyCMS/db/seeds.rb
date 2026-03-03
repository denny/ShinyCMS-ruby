# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This file loads some data that every ShinyCMS installation needs;
# feature flags, capabilities for the admin area ACL, etc.
#
# You can reload this data at any time using `rails shinycms:db:seed`.

# Load capability data
require_relative 'seeds/capabilities'

# Load feature flag data
require_relative 'seeds/feature_flags'

# Load settings data
require_relative 'seeds/settings'

# Load seed data for any ShinyCMS feature plugins that are enabled
ShinyCMS.plugins.each do |plugin|
  Rake::Task[ "#{plugin.underscore}:db:seed" ].invoke
end

# Load default dashboard data for Blazer
require_relative 'seeds/blazer'

# If there are currently no super-admin users, show the command to create one
demo = ( Rake.application.top_level_tasks.first == 'shinycms:demo:load' )
skip = ShinyCMS::User.super_admins_exist? || demo || Rails.env.test?
puts 'To generate a ShinyCMS admin user: rails shinycms:admin:create' unless skip
