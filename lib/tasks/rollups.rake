# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'dotenv/tasks'

# ShinyCMS tasks for generated aggregated stats, and deleting the full data (to save space)

namespace :shiny do
  namespace :db do
    desc 'ShinyCMS: aggregate web traffic data'
    # :nocov:
    task rollup: %i[ environment dotenv ] do
      rollup_ahoy
    end
    # :nocov:

    desc 'ShinyCMS: aggregate web traffic data, and remove the full data'
    # :nocov:
    task rollup_and_remove: %i[ environment dotenv ] do
      rollup_ahoy

      Ahoy::Visit.where( 'started_at < ?', 7.days.ago ).delete_all
    end

    def rollup_ahoy
      Rollup.week_start = :monday

      Ahoy::Visit.rollup( 'Visits', interval: :hour )
      Ahoy::Visit.where.not( user_id: nil ).rollup( 'Visits (logged-in users)', interval: :hour )

      Ahoy::Event.where( name: 'Ran action' )
                 .where_props( controller: 'shiny_blog/blog', action: 'show' )
                 .group_prop( :year, :month, :title )
                 .rollup( 'Blog post views' )
    end
    # :nocov:
  end
end
