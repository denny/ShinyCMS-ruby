# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Test for custom find_by method on Capability model
RSpec.describe ShinyCMS::Capability, type: :model do
  describe '.find_by' do
    context 'when passed the right two params' do
      it 'does the custom lookup' do
        result = described_class.find_by( capability: 'view_admin_area', category: 'general' )

        expect( result      ).to be_a described_class
        expect( result.name ).to eq 'view_admin_area'
      end
    end

    context 'when passed any other params' do
      it 'does a normal lookup' do
        result = described_class.find_by( name: 'view_admin_area' )

        expect( result      ).to be_a described_class
        expect( result.name ).to eq 'view_admin_area'
      end
    end
  end
end
