# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared test code, for testing methods and behaviour mixed-in by the ShinyName concern
RSpec.shared_examples ShinyCMS::ShinyName do
  describe '.name' do
    it 'returns the public_name if one is set' do
      named.public_name = Faker::Books::CultureSeries.unique.culture_ship

      expect( named.name ).not_to eq named.internal_name
      expect( named.name ).to     eq named.public_name
    end

    it 'returns the internal_name if public_name is not set' do
      named.public_name = nil

      expect( named.name ).not_to eq named.public_name
      expect( named.name ).to     eq named.internal_name
    end
  end
end
