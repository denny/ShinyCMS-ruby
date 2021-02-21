# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Plugins model (represents a collection of plugins)
RSpec.describe ShinyCMS::Plugins, type: :model do
  describe 'Plugins.get' do
    it 'returns a Plugins object for all feature plugins' do
      test1 = described_class.get

      expect( test1 ).to respond_to :each
      expect( test1 ).to all be_a ShinyCMS::Plugin

      expect( test1.include?( :ShinyCMS ) ).to be false
    end

    context 'when a subset of plugin names is passed in as strings' do
      it 'returns a Plugins object for those plugins' do
        test_plugins = %w[ ShinyCMS ShinyNews ShinyAccess ]

        test3 = described_class.get( test_plugins )

        expect( test3.include?( :ShinyNews ) ).to be true
        expect( test3.include?( :ShinyBlog ) ).to be false
      end
    end

    context 'when a subset of plugin names is passed in as symbols' do
      it 'returns a Plugins object for those plugins' do
        test_plugins = %i[ ShinyCMS ShinyBlog ShinyAccess ]

        test3 = described_class.get( test_plugins )

        expect( test3.include?( :ShinyBlog ) ).to be true
        expect( test3.include?( :ShinyNews ) ).to be false
      end
    end

    context 'when a non-existent plugin name is passed in' do
      it 'raises an exception' do
        expect { described_class.get( :FAIL ) }.to raise_error ArgumentError
      end
    end
  end

  describe '.include?' do
    it 'returns true if the named plugin is in its set' do
      expect( described_class.include?( :ShinySearch ) ).to be true
    end
  end

  describe '.loaded?' do
    it 'returns true if the named plugin is in its set AND defined as a constant' do
      expect( described_class.loaded?( :ShinySearch ) ).to be true
    end
  end

  describe '.routes' do
    it 'returns an array (or similar) of route objects' do
      routes = described_class.get.routes

      expect( routes ).to respond_to :each
      expect( routes ).to all be_a ActionDispatch::Journey::Route
    end
  end
end
