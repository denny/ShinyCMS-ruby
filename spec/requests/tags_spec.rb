# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  describe 'GET /tags/cloud' do
    it 'displays the tag cloud' do
      get tag_cloud_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'tags.cloud.title' )
    end
  end

  describe 'GET /tags/list' do
    it 'displays the tag list' do
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
      Setting.set( :tag_view, to: 'list' )

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
