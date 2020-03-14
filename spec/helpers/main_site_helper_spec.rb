require 'rails_helper'

RSpec.describe MainSiteHelper, type: :helper do
  describe 'setting' do
    it 'returns the setting value' do
      s1 = create :setting, name: 'testing_testing'
      create :setting_value, setting_id: s1.id, value: '1 2 1 2'

      expect( helper.setting( :testing_testing ) ).to eq '1 2 1 2'
    end
  end
end
