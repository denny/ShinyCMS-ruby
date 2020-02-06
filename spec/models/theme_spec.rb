require 'rails_helper'

RSpec.describe Theme, type: :model do
  before :all do
    FileUtils.mkdir 'app/views/themes/test1'
    FileUtils.mkdir 'app/views/themes/test2'
  end

  after :all do
    FileUtils.rmdir 'app/views/themes/test1'
    FileUtils.rmdir 'app/views/themes/test2'
  end

  context 'no theme settings' do
    it 'returns nil' do
      temp = ENV['SHINYCMS_THEME']
      ENV['SHINYCMS_THEME'] = nil
      theme = Theme.current
      ENV['SHINYCMS_THEME'] = temp

      expect( theme ).to eq nil
    end
  end

  context 'ENV theme setting' do
    it 'returns the configured theme if the theme folder exists' do
      temp = ENV['SHINYCMS_THEME']
      ENV['SHINYCMS_THEME'] = 'test1'
      theme = Theme.current
      ENV['SHINYCMS_THEME'] = temp

      expect( theme.name ).to eq 'test1'
    end

    it 'returns nil if the theme folder does not exist' do
      temp = ENV['SHINYCMS_THEME']
      ENV['SHINYCMS_THEME'] = 'test3'
      theme = Theme.current
      ENV['SHINYCMS_THEME'] = temp

      expect( theme ).to eq nil
    end
  end

  context 'site theme setting' do
    it 'returns the configured theme' do
      temp = ENV['SHINYCMS_THEME']
      ENV['SHINYCMS_THEME'] = 'test1'

      setting = create :setting, name: 'theme_name'
      create :setting_value, setting_id: setting.id, value: 'test2'

      theme = Theme.current
      ENV['SHINYCMS_THEME'] = temp

      expect( theme.name ).to eq 'test2'
    end
  end

  context 'user theme setting' do
    it "returns the user's chosen theme if valid" do
      temp = ENV['SHINYCMS_THEME']
      ENV['SHINYCMS_THEME'] = 'test1'

      user    = create :admin_user
      setting = create :setting, name: 'theme_name', level: 'admin'
      create :setting_value, user_id: user.id,
                             setting_id: setting.id,
                             value: 'test2'

      theme = Theme.current( user )
      ENV['SHINYCMS_THEME'] = temp

      expect( theme.name ).to eq 'test2'
    end

    it "returns the site's default theme if the user theme is invalid" do
      temp = ENV['SHINYCMS_THEME']
      ENV['SHINYCMS_THEME'] = 'test1'

      user    = create :user
      setting = create :setting, name: 'theme_name', level: 'user'
      create :setting_value, user_id: user.id,
                             setting_id: setting.id,
                             value: 'test3'

      theme = Theme.current( user )
      ENV['SHINYCMS_THEME'] = temp

      expect( theme.name ).to eq 'test1'
    end
  end
end
