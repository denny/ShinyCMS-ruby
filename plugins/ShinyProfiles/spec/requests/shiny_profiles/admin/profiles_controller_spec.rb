# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for admin area controller
RSpec.describe ShinyProfiles::Admin::ProfilesController, type: :request do
  before do
    admin = create :user_admin
    sign_in admin
  end

  describe 'GET /admin/profiles/123/edit' do
    it "renders the user's edit-profile page" do
      user = create :user

      get shiny_profiles.admin_edit_profile_path( user.profile )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_profiles.admin.profiles.edit.title' ).titlecase
    end
  end

  describe 'PUT /admin/profiles/123' do
    it 'saves the new profile details' do
      user = create :user

      new_email = Faker::Internet.unique.email.sub( '@', ' AT ' )

      put shiny_profiles.admin_profile_path( user.profile ), params: {
        profile: {
          public_email: new_email
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_profiles.admin_edit_profile_path( user.profile )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_field 'profile[public_email]', with: new_email
    end
  end
end
