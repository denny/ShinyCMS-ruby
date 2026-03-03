# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Plugin model (represents a single plugin)
RSpec.describe ShinyCMS::Plugin, type: :model do
  describe '.models_that_include( concern )' do
    it 'returns an array of models from this plugin' do
      plugin = described_class.get( 'ShinyBlog' )
      models = plugin.models_that_include ShinyCMS::ProvidesDemoSiteData

      expect( models ).to be_an Enumerable
      expect( models.first.name ).to eq 'ShinyBlog::Post'
    end
  end
end
