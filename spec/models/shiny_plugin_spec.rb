# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyPlugin model
RSpec.describe ShinyPlugin, type: :model do
  context 'class methods' do
    describe '.loaded' do
      it 'returns an array of plugin instances' do
        expect( ShinyPlugin.loaded       ).to be_an Array
        expect( ShinyPlugin.loaded.first ).to be_a ShinyPlugin
      end
    end

    describe '.loaded_names' do
      it 'returns an array of plugin names' do
        expect( ShinyPlugin.loaded_names       ).to be_an Array
        expect( ShinyPlugin.loaded_names.first ).to be_a String
      end
    end

    describe '.loaded?' do
      it 'returns true if the named plugin is loaded' do
        expect( ShinyPlugin.loaded?( 'ShinySearch' ) ).to be true
      end
    end

    describe '.models_with_demo_data' do
      it 'returns an array of model class names' do
        expect( ShinyPlugin.models_with_demo_data       ).to be_an Array
        expect( ShinyPlugin.models_with_demo_data.first ).to be_a String
      end
    end
  end

  context 'instance methods' do
    describe '.models_with_demo_data' do
      it 'returns an array of models' do
        plugin = ShinyPlugin.new( 'ShinyBlog' )
        models = plugin.models_with_demo_data

        expect( models            ).to be_an Array
        expect( models.first      ).to be_a Class
        expect( models.first.name ).to eq 'ShinyBlog::Post'
      end
    end

    describe '.admin_index_path' do
      it 'returns the approriate path' do
        plugin = ShinyPlugin.new( 'ShinyBlog' )
        path = plugin.admin_index_path( 'blog_posts' )

        expect( path ).to be_a String
      end
    end
  end
end
