# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Plugin model (represents a single plugin)
RSpec.describe ShinyCMS::Plugin, type: :model do
  describe 'class methods' do
    describe '.loaded' do
      it 'returns an array of plugin instances' do
        expect( described_class.loaded ).to be_an Array
        expect( described_class.loaded ).to all be_a described_class
      end
    end

    describe '.loaded_names' do
      it 'returns an array of plugin names' do
        expect( described_class.loaded_names ).to be_an Array
        expect( described_class.loaded_names ).to all be_a String
      end
    end

    describe '.loaded?' do
      it 'returns true if the named plugin is loaded' do
        expect( described_class.loaded?( 'ShinySearch' ) ).to be true
      end
    end

    describe '.models_that_respond_to' do
      it 'returns an array (or similar) of models from the whole app' do
        models = described_class.models_that_respond_to :dump_for_demo?

        expect( models       ).to respond_to :each
        expect( models.first ).to be ShinyAccess::Group
      end
    end
  end

  describe 'instance methods' do
    describe '.models_that_respond_to( :method? )' do
      it 'returns an array of models from this plugin' do
        plugin = described_class.new( 'ShinyBlog' )
        models = plugin.models_that_respond_to :dump_for_demo?

        expect( models       ).to be_an Array
        expect( models.first ).to be ShinyBlog::Post
      end
    end
  end
end
