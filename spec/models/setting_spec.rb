require 'rails_helper'

RSpec.describe Setting, type: :model do
  context '.get' do
    it 'returns the specified setting' do
      setting = create :setting, name: 'foo'
      create :setting_value, setting_id: setting.id, value: 'bar'
      expect( Setting.get( :foo ) ).to eq 'bar'
    end
  end

  it 'fails validation when updating a locked setting' do
    setting = create :setting, name: 'foo', level: 'site', locked: true

    _null = setting.update( level: 'user' )

    expect( setting.errors[:base] ).to include 'Attempted to update a locked setting'
  end

  it 'raises an error when updating a locked setting without validations' do
    setting = create :setting, name: 'foo', level: 'site', locked: true

    setting.level = 'user'
    expect { setting.save( validate: false ) }
      .to raise_error Setting::CannotUpdateLocked, 'Attempted to update a locked setting'
  end
end
