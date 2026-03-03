# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyCMS::Users::PasswordsController, type: :request do
  # Passwords controller; almost entirely handled by Devise
  before do
    ShinyCMS::FeatureFlag.enable :user_login
    ShinyCMS::FeatureFlag.disable :user_profiles

    create :top_level_page
  end

  describe 'GET new user password page' do
    it 'renders the new password page' do
      get shinycms.new_user_password_path

      expect( response ).to have_http_status :ok
    end
  end
end
