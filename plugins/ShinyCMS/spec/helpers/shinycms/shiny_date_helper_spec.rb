# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for date helper methods
RSpec.describe ShinyCMS::ShinyDateHelper, type: :helper do
  describe 'display_date_at_time( utc_time )' do
    it 'returns a nicely-formatted date and time string, in localtime, date first' do
      input = Time.zone.now

      result = helper.display_date_at_time( input )

      expect( result ).to be_a String
      expect( result ).to match %r{\w\w\w, \d\d \w\w\w \d\d\d\d at \d\d:\d\d}
    end
  end

  describe 'display_time_on_date( utc_time )' do
    it 'returns a nicely-formatted time and date string, in localtime, time first' do
      input = Time.zone.now

      result = helper.display_time_on_date( input )

      expect( result ).to be_a String
      expect( result ).to match %r{\d\d:\d\d on \w\w\w, \d\d \w\w\w \d\d\d\d}
    end
  end

  describe 'display_date( utc_time )' do
    it 'returns a nicely-formatted date string, in localtime' do
      input = Time.zone.now

      result = helper.display_date( input )

      expect( result ).to be_a String
      expect( result ).to match %r{\w\w\w, \d\d \w\w\w \d\d\d\d}
    end
  end

  describe 'display_time( utc_time )' do
    it 'returns a nicely-formatted time string, in localtime' do
      input = Time.zone.now

      result = helper.display_time( input )

      expect( result ).to be_a String
      expect( result ).to match %r{\d\d:\d\d}
    end
  end

  describe 'convert_to_utc( local_time )' do
    it 'returns the equivalent Time in UTC' do
      input = Time.zone.now.getlocal

      result = helper.convert_to_utc( input )

      expect( result ).to be_a Time
      expect( result.utc? ).to be true
    end
  end
end
