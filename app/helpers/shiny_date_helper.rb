# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Useful methods for displaying/saving dates and times
module ShinyDateHelper
  def convert_to_utc( input )
    return unless input.is_a? Time

    Time.local( *input.to_a ).utc
  end

  def display_date_and_time( timestamp )
    return unless timestamp.is_a? Time

    date = timestamp.localtime.to_s :shinydate
    time = timestamp.localtime.to_s :time

    I18n.t( 'shiny_display_date_helper.date_and_time', time: time, date: date )
  end

  def display_time_and_date( timestamp )
    return unless timestamp.is_a? Time

    date = timestamp.localtime.to_s :shinydate
    time = timestamp.localtime.to_s :time

    I18n.t( 'shiny_display_date_helper.time_and_date', time: time, date: date )
  end

  def display_date( timestamp )
    return unless timestamp.is_a? Time

    timestamp.localtime.to_s :shinydate
  end

  def display_time( timestamp )
    return unless timestamp.is_a? Time

    timestamp.localtime.to_s :time
  end
end
