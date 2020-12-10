# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyPlugin model
RSpec.describe ShinyPlugin, type: :model do
  describe 'class methods' do
    describe '.loaded' do
      it 'returns an array of plugin instances' do
        expect( described_class.loaded       ).to be_an Array
        expect( described_class.loaded.first ).to be_a described_class
      end
    end

    describe '.loaded_names' do
      it 'returns an array of plugin names' do
        expect( described_class.loaded_names       ).to be_an Array
        expect( described_class.loaded_names.first ).to be_a String
      end
    end

    describe '.loaded?' do
      it 'returns true if the named plugin is loaded' do
        expect( described_class.loaded?( 'ShinySearch' ) ).to be true
      end
    end

    describe '.models_with_demo_data' do
      it 'returns an array of model class names' do
        expect( described_class.models_with_demo_data       ).to be_an Array
        expect( described_class.models_with_demo_data.first ).to be_a String
      end
    end
  end

  describe 'instance methods' do
    describe '.models_with_demo_data' do
      it 'returns an array of models' do
        plugin = described_class.new( 'ShinyBlog' )
        models = plugin.models_with_demo_data

        expect( models            ).to be_an Array
        expect( models.first      ).to be_a Class
        expect( models.first.name ).to eq 'ShinyBlog::Post'
      end
    end
  end
end
