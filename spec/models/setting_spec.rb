require 'rails_helper'

RSpec.describe Setting, type: :model do
  context '.get' do
    it 'returns the specified setting' do
      setting = create :setting, name: 'foo'
      create :setting_value, setting_id: setting.id, value: 'bar'
      expect( Setting.get( :foo ) ).to eq 'bar'
    end
  end
end
