# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Plugins model (represents a collection of plugins)
RSpec.describe ShinyCMS::PluginsSugar, type: :model do
  describe '.all' do
    it 'includes the core plugin in its plugin set' do
      expect( ShinyCMS::Plugins.all.include?( 'ShinyCMS' ) ).to be true
    end
  end
end
