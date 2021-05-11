# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

RSpec.shared_examples ShinyCMS::ProvidesDemoSiteData do
  describe '.demo_data_position' do
    it 'returns a number' do
      expect( model.demo_data_position ).to be_a Integer
    end
  end
end
