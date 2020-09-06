# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyCMS theme model
RSpec.describe Theme, type: :model do
  before :all do
    FileUtils.mkdir 'app/views/themes/test1'
    FileUtils.mkdir 'app/views/themes/test2'
  end

  before :each do
    allow( Theme ).to receive( :env_shinycms_theme ).and_return( 'test1' )
  end

  after :all do
    FileUtils.rmdir 'app/views/themes/test1'
    FileUtils.rmdir 'app/views/themes/test2'
  end

  context 'when there are no theme settings' do
    it 'it returns nil' do
      allow( Theme ).to receive( :env_shinycms_theme ).and_return( nil )

      expect( Theme.current ).to eq nil
    end
  end

  context 'when there is an ENV theme setting' do
    it 'it returns the configured theme if the theme folder exists' do
      expect( Theme.current.name ).to eq 'test1'
    end

    it 'it returns nil if the theme folder does not exist' do
      allow( Theme ).to receive( :env_shinycms_theme ).and_return( 'test3' )

      expect( Theme.current ).to eq nil
    end
  end

  context 'when there is a site-wide theme name setting' do
    it 'it returns the configured theme' do
      allow( Setting ).to receive( :get ).and_return( 'test2' )

      expect( Theme.current.name ).to eq 'test2'
    end
  end

  context 'when there is a user-level theme name setting' do
    it "it returns the user's chosen theme if valid" do
      setting = Setting.find_by( name: 'theme_name' )
      setting.update!( level: 'user' )
      user    = create :admin_user
      create :setting_value, user_id: user.id, setting_id: setting.id, value: 'test2'

      expect( Theme.current( user ).name ).to eq 'test2'
    end

    it "it returns the site's default theme if the user theme is invalid" do
      setting = Setting.find_by( name: 'theme_name' )
      setting.update!( level: 'user' )
      user    = create :user
      create :setting_value, user_id: user.id, setting_id: setting.id, value: 'test3'

      expect( Theme.current( user ).name ).to eq 'test1'
    end
  end
end
