# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests helper methods mixed in to the Plugins class
RSpec.describe ShinyCMS::PluginsComponents, type: :model do
  describe '.models_that_respond_to' do
    it 'returns an array (or similar) of models from the whole app' do
      models = ShinyCMS::Plugins.all.models_that_include ShinyCMS::ProvidesDemoSiteData

      expect( models ).to be_an Enumerable

      expect( models.first ).to be ShinyAccess::Group
      expect( models.last  ).to be ShinyProfiles::Profile
    end
  end

  describe '.routes' do
    it 'returns an array (or similar) of route objects' do
      routes = ShinyCMS::Plugins.all.routes

      expect( routes ).to be_an Enumerable
      expect( routes ).to all be_a ActionDispatch::Journey::Route
    end
  end
end
