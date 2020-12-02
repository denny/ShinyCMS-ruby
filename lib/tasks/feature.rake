# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# ShinyCMS feature flag administration tasks

# List all feature flags with on/off status: rails shiny:features:list
# Turn a feature on  (for all user types):   rails shiny:feature:on[user_login]
# Turn a feature off (for all user types):   rails shiny:feature:off[user_profiles]

namespace :shiny do
  namespace :features do
    # :nocov:
    desc 'ShinyCMS: list feature flags and status'
    task list: %i[ environment dotenv ] do
      FeatureFlag.order( :name ).each do |flag|
        a = flag.enabled_for_admins?    ? '+' : '-'
        l = flag.enabled_for_logged_in? ? '+' : '-'
        e = flag.enabled?               ? '+' : '-'
        puts "#{a}#{l}#{e} #{flag.name}"
      end
      puts '^^^'
      puts 'ALE [ Admin / Logged-in / Everybody ]'
    end
    # :nocov:
  end

  namespace :feature do
    # :nocov:
    desc 'ShinyCMS: toggle a feature flag on'
    task :on, [ :name ] => %i[ environment dotenv ] do |_t, args|
      flag = FeatureFlag.enable args[:name]
      puts "Set enabled=true for #{args[:name]}" if flag.valid?
    end

    desc 'ShinyCMS: toggle a feature flag off'
    task :off, [ :name ] => %i[ environment dotenv ] do |_t, args|
      flag = FeatureFlag.disable args[:name]
      puts "Set enabled=false for #{args[:name]}" if flag.valid?
    end
    # :nocov:
  end
end
