require 'rails_helper'

RSpec.describe SiteSetting, type: :model do
  context '.get' do
    it 'returns the specified setting' do
      create :site_setting, name: 'foo', value: 'bar'
      expect( SiteSetting.get( 'foo' ) ).to eq 'bar'
    end
  end
end
