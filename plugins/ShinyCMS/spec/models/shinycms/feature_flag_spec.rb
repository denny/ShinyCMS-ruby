# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for feature flag model
RSpec.describe ShinyCMS::FeatureFlag, type: :model do
  describe 'instance methods' do
    describe '.enabled?' do
      it 'returns false if the feature is not enabled' do
        flag = create :feature_flag

        expect( flag.enabled? ).to be false
      end

      it 'returns true if the feature is enabled' do
        flag = create :feature_flag, enabled: true

        expect( flag.enabled? ).to be true
      end
    end

    describe '.enabled_for_admins?' do
      it 'returns false if the feature is enabled but not enabled for admins' do
        flag = create :feature_flag, enabled: true

        expect( flag.enabled_for_admins? ).to be false
      end

      it 'returns true if the feature is enabled for admins' do
        flag = create :feature_flag, enabled_for_admins: true

        expect( flag.enabled_for_admins? ).to be true
      end
    end
  end
end
