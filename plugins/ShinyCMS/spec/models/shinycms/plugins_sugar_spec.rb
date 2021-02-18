# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests helper methods mixed in to the Plugins class
RSpec.describe ShinyCMS::PluginsSugar, type: :model do
  describe '.all' do
    it 'includes the core plugin in its plugin set' do
      expect( ShinyCMS::Plugins.all.include?( 'ShinyCMS' ) ).to be true
    end
  end

  describe '.models_that_respond_to' do
    it 'returns an array (or similar) of models from the whole app' do
      models = ShinyCMS::Plugins.models_that_respond_to :dump_for_demo?

      expect( models       ).to respond_to :each
      expect( models.first ).to be ShinyAccess::Group
      expect( models.last  ).to be ShinyProfiles::Profile
    end
  end
end
