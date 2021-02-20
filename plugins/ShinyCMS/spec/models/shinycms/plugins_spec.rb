# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Plugins model (represents a collection of plugins)
RSpec.describe ShinyCMS::Plugins, type: :model do
  describe 'Plugins.new' do
    context 'when no params are specified' do
      it 'returns a Plugins object for all feature plugins' do
        test1 = described_class.new

        expect( test1.include?( 'ShinyCMS' ) ).to be false
      end
    end

    context 'when a subset of plugin names is passed in' do
      it 'returns a Plugins object for those plugins' do
        test_plugins = %w[ ShinyCMS ShinyNews ShinyAccess ]

        test3 = described_class.new( test_plugins )

        expect( test3.include?( 'ShinyNews' ) ).to be true
        expect( test3.include?( 'ShinyBlog' ) ).to be false
      end
    end

    context 'when a non-existent plugin name is passed in' do
      it 'raises an exception' do
        expect { described_class.new( :FAIL ) }.to raise_error ArgumentError
      end
    end
  end

  describe '.include?' do
    it 'returns true if the named plugin is loaded' do
      expect( described_class.include?( :ShinySearch ) ).to be true
    end
  end

  describe '.routes' do
    it 'returns an array (or similar) of route objects' do
      routes = described_class.all.routes

      expect( routes ).to respond_to :each
      expect( routes ).to all be_a ActionDispatch::Journey::Route
    end
  end

  describe '.loaded' do
    it 'returns an array (or similar) of plugin instances' do
      plugins = described_class.loaded

      expect( plugins ).to respond_to :each
      expect( plugins ).to all be_a ShinyCMS::Plugin
    end
  end

  describe '.all' do
    it 'includes the core plugin in its plugin set' do
      expect( described_class.all.include?( 'ShinyCMS' ) ).to be true
    end
  end
end