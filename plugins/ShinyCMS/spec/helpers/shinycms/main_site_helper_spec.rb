# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for some of the methods in the main site helper module
RSpec.describe ShinyCMS::MainSiteHelper, type: :helper do
  describe 'setting' do
    it 'returns the setting value' do
      s1 = create :setting, name: 'testing_testing'
      create :setting_value, setting_id: s1.id, value: '1 2 1 2'

      expect( helper.setting( :testing_testing ) ).to eq '1 2 1 2'
    end
  end

  describe 'consent_version' do
    it 'returns the matching consent version' do
      create :consent_version, name: 'Testing, testing', slug: 'testing'

      expect( helper.consent_version( 'testing' ).name ).to eq 'Testing, testing'
    end
  end
end
