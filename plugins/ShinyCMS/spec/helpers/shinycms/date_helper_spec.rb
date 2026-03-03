# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for date helper methods
RSpec.describe ShinyCMS::DatesHelper, type: :helper do
  describe 'display_date_at_time( utc_time )' do
    it 'returns a nicely-formatted date and time string, date first' do
      input = Time.zone.now

      result = helper.display_date_at_time( input )

      expect( result ).to be_a String
      expect( result ).to match %r{\w\w\w, \d\d \w\w\w \d\d\d\d at \d\d:\d\d}
    end
  end

  describe 'display_time_on_date( utc_time )' do
    it 'returns a nicely-formatted time and date string, time first' do
      input = Time.zone.now

      result = helper.display_time_on_date( input )

      expect( result ).to be_a String
      expect( result ).to match %r{\d\d:\d\d on \w\w\w, \d\d \w\w\w \d\d\d\d}
    end
  end

  describe 'display_date( utc_time )' do
    it 'returns a nicely-formatted date string' do
      input = Time.zone.now

      result = helper.display_date( input )

      expect( result ).to be_a String
      expect( result ).to match %r{\w\w\w, \d\d \w\w\w \d\d\d\d}
    end
  end

  describe 'display_time( utc_time )' do
    it 'returns a nicely-formatted time string' do
      input = Time.zone.now

      result = helper.display_time( input )

      expect( result ).to be_a String
      expect( result ).to match %r{\d\d:\d\d}
    end
  end
end
