require 'rails_helper'

RSpec.describe FeatureFlag, type: :model do
  context 'FeatureFlag.on?' do
    it 'returns false if the flag is set off' do
      flag = create :feature_flag

      expect( flag.on? ).to be false
    end

    it 'returns false if the flag is not set' do
      flag = create :feature_flag, state: nil

      expect( flag.on? ).to be false
    end

    it 'returns true if the flag is set on' do
      flag = create :feature_flag, state: 'On'

      expect( flag.on? ).to be true
    end
  end
end
