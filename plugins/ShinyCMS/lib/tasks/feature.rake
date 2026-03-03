# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# ShinyCMS feature flag administration tasks

# Usage:
#   rails shinycms:features:list           # List all feature flags, with on/off status
#   rails shinycms:feature:on[user_login]  # Turn a feature on  (for all users)
#   rails shinycms:feature:off[comments]   # Turn a feature off (for all users)

namespace :shinycms do
  namespace :features do
    desc 'ShinyCMS: list feature flags and status'
    task list: %i[ environment dotenv ] do
      # :nocov:
      ShinyCMS::FeatureFlag.order( :name ).each do |flag|
        a = flag.enabled_for_admins?    ? '+' : '-'
        l = flag.enabled_for_logged_in? ? '+' : '-'
        e = flag.enabled?               ? '+' : '-'
        puts "#{a}#{l}#{e} #{flag.name}"
      end
      puts '^^^'
      puts 'ALE [ Admin / Logged-in / Everybody ]'
      # :nocov:
    end
  end

  namespace :feature do
    desc 'ShinyCMS: toggle a feature flag on'
    task :on, [ :name ] => %i[ environment dotenv ] do |_t, args|
      # :nocov:
      flag = ShinyCMS::FeatureFlag.enable args[:name]
      puts "Set enabled=true for #{args[:name]}" if flag.valid?
      # :nocov:
    end

    desc 'ShinyCMS: toggle a feature flag off'
    task :off, [ :name ] => %i[ environment dotenv ] do |_t, args|
      # :nocov:
      flag = ShinyCMS::FeatureFlag.disable args[:name]
      puts "Set enabled=false for #{args[:name]}" if flag.valid?
      # :nocov:
    end
  end
end
