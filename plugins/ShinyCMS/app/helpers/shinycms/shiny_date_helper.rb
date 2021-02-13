# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Useful methods for displaying/saving dates and times
  # TODO: FIXME: all the timezone-related code in here is wrong and needs replacing :)
  module ShinyDateHelper
    def display_date_at_time( timestamp )
      return unless timestamp.is_a? Time

      date = timestamp.localtime.to_s :shinydate_with_day
      time = timestamp.localtime.to_s :time

      I18n.t( 'shiny_date_helper.date_at_time', time: time, date: date )
    end

    def display_time_on_date( timestamp )
      return unless timestamp.is_a? Time

      date = timestamp.localtime.to_s :shinydate_with_day
      time = timestamp.localtime.to_s :time

      I18n.t( 'shiny_date_helper.time_on_date', time: time, date: date )
    end

    def display_time_on_date_no_day( timestamp )
      return unless timestamp.is_a? Time

      date = timestamp.localtime.to_s :shinydate
      time = timestamp.localtime.to_s :time

      I18n.t( 'shiny_date_helper.time_on_date', time: time, date: date )
    end

    def display_date( timestamp )
      return unless timestamp.is_a? Time

      timestamp.localtime.to_s :shinydate_with_day
    end

    def display_time( timestamp )
      return unless timestamp.is_a? Time

      timestamp.localtime.to_s :time
    end

    def combine_date_and_time_params( params_hash, date_input_name )
      date_string = params_hash[ date_input_name ]
      time_string = params_hash.delete( "#{date_input_name}_time" )

      params_hash[ date_input_name.to_sym ] = "#{date_string} #{time_string}".strip
      params_hash
    end

    def convert_to_utc( input )
      return unless input.is_a? Time

      Time.local( *input.to_a ).utc
    end
  end
end
