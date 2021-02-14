# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for tagging features on main site (powered by ActsAsTaggableOn)
RSpec.describe ShinyCMS::TagsController, type: :request do
  describe 'GET /tags/cloud' do
    it 'displays the tag cloud' do
      get tag_cloud_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'tags.cloud.title' )
    end
  end

  describe 'GET /tags/list' do
    it 'displays the tag list' do
      post1 = create :blog_post
      post1.tag_list = 'shiny'
      post1.save!

      get tag_list_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'tags.list.title' )
    end
  end

  describe 'GET /tags' do
    it 'displays the tag cloud if tag_view is not set' do
      get tags_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'tags.cloud.title' )
    end

    it "displays the tag list if tag_view is set to 'list'" do
      ShinyCMS::Setting.set( :tag_view, to: 'list' )

      get tags_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'tags.list.title' )
    end
  end

  describe 'GET /tag/test' do
    it 'displays content with the appropriate tag' do
      get tag_path( 'test' )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'tags.show.title', tag: 'test' )
    end
  end
end
