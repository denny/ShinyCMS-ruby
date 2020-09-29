# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for plugin helper methods
RSpec.describe ShinyPluginHelper, type: :helper do
  describe 'plugin_loaded?' do
    it 'returns true if the plugin is loaded' do
      expect( helper.plugin_loaded?( :ShinySearch ) ).to be true
    end

    it 'returns false if the plugin is not loaded' do
      expect( helper.plugin_loaded?( :NonExistentHelper ) ).to be false
    end
  end
end
