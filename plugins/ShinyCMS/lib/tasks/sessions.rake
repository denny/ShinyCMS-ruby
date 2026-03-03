# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# Task to clear short sessions (probably spambots?) out of the ShinyCMS database

# Usage:
#   rails shinycms:sessions:clean max=3  # Delete data for sessions up to 3 seconds long

namespace :shinycms do
  namespace :sessions do
    desc 'ShinyCMS: delete data for short sessions'
    task clean: %i[ environment dotenv ] do
      # :nocov:
      duration = ENV['max'].to_i

      unless duration.positive?
        raise ArgumentError, 'You must specify the maximum session length (in seconds) to delete'
      end
      if duration > 1.day.to_i
        raise ArgumentError, 'Maximum session length to delete must be less than 86,400 seconds (one day)'
      end

      ActiveRecord::Base.connection.execute( <<~SQL.squish )
        delete from sessions where created_at < current_date and (
          extract( epoch from updated_at ) - extract( epoch from created_at )
        ) < #{duration}
      SQL
      # :nocov:
    end
  end
end
