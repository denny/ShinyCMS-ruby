# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeatureFlag, type: :model do
  context '.enabled?' do
    it 'returns false if the feature is not enabled' do
      flag = create :feature_flag

      expect( flag.enabled? ).to be false
    end

    it 'returns true if the feature is enabled' do
      flag = create :feature_flag, enabled: true

      expect( flag.enabled? ).to be true
    end
  end

  context '.enabled_for_admins?' do
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
