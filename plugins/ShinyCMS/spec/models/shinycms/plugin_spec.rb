# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Plugin model (represents a single plugin)
RSpec.describe ShinyCMS::Plugin, type: :model do
  describe '.models_that_respond_to( :method? )' do
    it 'returns an array of models from this plugin' do
      plugin = described_class.new( 'ShinyBlog' )
      models = plugin.models_that_respond_to :demo_data?

      expect( models       ).to be_an Enumerable
      expect( models.first ).to be ShinyBlog::Post
    end
  end

  describe '.models_with_demo_data' do
    it 'returns an array of models, including comments and not including user data' do
      plugin = described_class.new( 'ShinyCMS' )

      demo_models = plugin.models_with_demo_data

      expect( demo_models ).to be_an Enumerable

      demo_model_names = demo_models.collect( &:name )

      expect( demo_model_names ).to     include 'ShinyCMS::Comment'
      expect( demo_model_names ).not_to include 'ShinyCMS::User'
    end
  end
end
