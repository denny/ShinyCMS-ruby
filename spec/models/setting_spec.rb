# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Setting model (combines with SettingValue to store site settings data)
RSpec.describe Setting, type: :model do
  context '.get' do
    it 'returns the specified setting' do
      setting = create :setting, name: 'foo'
      create :setting_value, setting_id: setting.id, value: 'bar'

      expect( Setting.get( :foo ) ).to eq 'bar'
    end

    it 'returns the specified admin setting if user is an admin' do
      setting = create :setting, name: 'foo', level: 'admin'
      create :setting_value, setting_id: setting.id, value: 'bar'
      user = create :admin_user

      expect( Setting.get( :foo, user ) ).to eq 'bar'
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
      .to raise_error Setting::CannotUpdateLockedSetting,
                      'Attempted to update a locked setting'
  end
end
