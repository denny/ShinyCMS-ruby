require 'rails_helper'

RSpec.describe MainSiteHelper, type: :helper do
  describe 'setting' do
    it 'returns the setting value' do
      s1 = create :setting, name: 'theme_name'
      create :setting_value, setting_id: s1.id, value: 'TEST'

      expect( helper.setting( :theme_name ) ).to eq 'TEST'
    end
  end
end
