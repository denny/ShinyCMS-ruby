# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyCMS Plugin model
RSpec.describe Plugin, type: :model do
  context 'class methods' do
    describe '.loaded' do
      it 'returns an array of plugin instances' do
        expect( Plugin.loaded ).to be_an Array
        expect( Plugin.loaded.first ).to be_a Plugin
      end
    end

    describe '.loaded_names' do
      it 'returns an array of plugin names' do
        expect( Plugin.loaded_names ).to be_an Array
        expect( Plugin.loaded_names.first ).to be_a String
      end
    end

    describe '.models_with_demo_data' do
      it 'returns an array of model class names' do
        expect( Plugin.models_with_demo_data ).to be_an Array
        expect( Plugin.models_with_demo_data.first ).to be_a String
      end
    end
  end

  context 'instance methods' do
    describe '.models_with_demo_data' do
      it 'returns an array of model class names' do
        plugin = Plugin.new( 'ShinyBlog' )
        models = plugin.models_with_demo_data

        expect( models ).to be_an Array
        expect( models.first ).to be_a String
        expect( models.first ).to eq 'ShinyBlog::Post'
      end
    end
  end
end
