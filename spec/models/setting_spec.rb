require 'rails_helper'

RSpec.describe Setting, type: :model do
  context '.get' do
    it 'returns the specified setting' do
      create :setting, name: 'foo', value: 'bar'
      expect( Setting.get( 'foo' ) ).to eq 'bar'
    end
  end
end
