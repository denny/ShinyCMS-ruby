# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for main site controller for profile links
RSpec.describe 'ShinyProfiles::LinksController', type: :request do
  before do
    FeatureFlag.enable :user_login
    FeatureFlag.enable :user_profiles
  end

  def json_delete( path )
    delete path, headers: { ACCEPT: 'application/json' }
  end

  describe 'DELETE /profile/:username/link/:id' do
    it "removes a link from the user's profile if it exists" do
      user = create :user
      sign_in user

      link = user.profile.links.create!(
        name: 'foo',
        url:  'bar'
      )
      link_id = link.id

      json_delete shiny_profiles.profile_link_path( user.username, link_id )

      expect( response ).to have_http_status :no_content

      expect( ShinyProfiles::Link.exists?( id: link_id ) ).to be false
    end

    it "returns success (204) even if the link doesn't exist" do
      user = create :user
      sign_in user

      json_delete shiny_profiles.profile_link_path( user.username, 999 )

      expect( response ).to have_http_status :no_content
    end

    it "doesn't try to delete the link if a user isn't logged in" do
      user = create :user

      link = user.profile.links.create!(
        name: 'foo',
        url:  'bar'
      )
      link_id = link.id

      json_delete shiny_profiles.profile_link_path( user.username, link_id )

      expect( response ).to have_http_status :unauthorized

      expect( ShinyProfiles::Link.exists?( id: link_id ) ).to be true
    end

    it "doesn't delete the link if the right user isn't logged in" do
      user1 = create :user
      user2 = create :user
      sign_in user2

      link = user1.profile.links.create!(
        name: 'foo',
        url:  'bar'
      )
      link_id = link.id

      json_delete shiny_profiles.profile_link_path( user1.username, link_id )

      expect( response ).to have_http_status :unauthorized

      expect( ShinyProfiles::Link.exists?( id: link_id ) ).to be true
    end

    it 'returns 404 if profiles are disabled', :production_error_responses do
      user = create :user
      sign_in user

      link = user.profile.links.create!(
        name: 'foo',
        url:  'bar'
      )
      link_id = link.id

      FeatureFlag.disable :user_profiles

      json_delete shiny_profiles.profile_link_path( user.username, link_id )

      expect( response ).to have_http_status :not_found
    end
  end
end
