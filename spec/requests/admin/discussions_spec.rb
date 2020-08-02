# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Discussion moderation', type: :request do
  before :each do
    @admin = create :discussion_admin
    sign_in @admin

    FeatureFlag.enable :comments

    post = create :blog_post
    @discussion = create :discussion, resource: post

    @comment1 = create :top_level_comment, discussion: @discussion
    @comment2 = create :top_level_comment, discussion: @discussion
    create :top_level_comment, discussion: @discussion

    @nested = create :nested_comment, discussion: @discussion, parent: @comment1
  end

  describe 'PUT /admin/discussion/1/hide' do
    it 'hides the discussion' do
      put hide_discussion_path( @discussion )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).not_to have_css 'h2', text: @nested.title
      expect( response.body ).not_to have_css 'h2', text: @comment2.title
    end
  end

  describe 'PUT /admin/discussion/1/show' do
    it 'unhides the discussion' do
      @discussion.hide
      expect( @discussion.reload.hidden? ).to be true

      put show_discussion_path( @discussion )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h2', text: @comment1.title
      expect( response.body ).to have_css 'h2', text: @nested.title
    end
  end

  describe 'PUT /admin/discussion/1/lock' do
    it 'locks the discussion' do
      put lock_discussion_path( @discussion )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @discussion.reload.locked? ).to be true
    end
  end

  describe 'PUT /admin/discussion/1/unlock' do
    it 'unlocks the discussion' do
      @discussion.lock
      expect( @discussion.reload.locked? ).to be true

      put unlock_discussion_path( @discussion )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @discussion.reload.locked? ).to be false
    end
  end
end
