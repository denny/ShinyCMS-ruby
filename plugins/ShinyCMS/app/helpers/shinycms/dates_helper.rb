# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Useful methods for displaying/saving dates and times
  module DatesHelper
    def display_date_at_time( timestamp )
      return unless timestamp.is_a? Time

      date = timestamp.localtime.to_fs :shinydate_with_day
      time = timestamp.localtime.to_fs :time

      I18n.t( 'shinycms.shiny_date_helper.date_at_time', time: time, date: date )
    end

    def display_time_on_date( timestamp )
      return unless timestamp.is_a? Time

      date = timestamp.localtime.to_fs :shinydate_with_day
      time = timestamp.localtime.to_fs :time

      I18n.t( 'shinycms.shiny_date_helper.time_on_date', time: time, date: date )
    end

    def display_time_on_date_no_day( timestamp )
      return unless timestamp.is_a? Time

      date = timestamp.localtime.to_fs :shinydate
      time = timestamp.localtime.to_fs :time

      I18n.t( 'shinycms.shiny_date_helper.time_on_date', time: time, date: date )
    end

    def display_date( timestamp )
      return unless timestamp.is_a? Time

      timestamp.localtime.to_fs :shinydate_with_day
    end

    def display_time( timestamp )
      return unless timestamp.is_a? Time

      timestamp.localtime.to_fs :time
    end
  end
end
