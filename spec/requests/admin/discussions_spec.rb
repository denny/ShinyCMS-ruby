require 'rails_helper'

RSpec.describe 'Discussion and comment moderation', type: :request do
  before :each do
    @admin = create :comment_admin
    sign_in @admin

    FeatureFlag.enable :comments

    post = create :blog_post
    @discussion = create :discussion, resource: post

    @comment1 = create :top_level_comment, discussion: @discussion
    @comment2 = create :top_level_comment, discussion: @discussion
    create :top_level_comment, discussion: @discussion

    @nested = create :nested_comment, discussion: @discussion, parent: @comment1
  end

  describe 'GET /admin/discussion/1/hide' do
    it 'hides the discussion' do
      get hide_discussion_path( @discussion )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).not_to have_css 'h2', text: @nested.title
      expect( response.body ).not_to have_css 'h2', text: @comment2.title
    end
  end

  describe 'GET /admin/discussion/1/unhide' do
    it 'unhides the discussion' do
      @discussion.hide
      expect( @discussion.reload.hidden? ).to be true

      get unhide_discussion_path( @discussion )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h2', text: @comment1.title
      expect( response.body ).to have_css 'h2', text: @nested.title
    end
  end

  describe 'GET /admin/discussion/1/lock' do
    it 'locks the discussion' do
      get lock_discussion_path( @discussion )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @discussion.reload.locked? ).to be true
    end
  end

  describe 'GET /admin/discussion/1/unlock' do
    it 'unlocks the discussion' do
      @discussion.lock
      expect( @discussion.reload.locked? ).to be true

      get unlock_discussion_path( @discussion )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @discussion.reload.locked? ).to be false
    end
  end

  describe 'GET /admin/discussion/1/hide/1' do
    it 'hides the comment' do
      get hide_comment_path( @discussion.id, @comment2.number )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: @nested.title
      expect( response.body ).not_to have_css 'h2', text: @comment2.title
      expect( response.body ).to     have_css 'i',  text: I18n.t( 'discussions.hidden_comment' )
    end
  end

  describe 'GET /admin/discussion/1/unhide/1' do
    it 'unhides the comment' do
      @comment2.hide
      expect( @comment2.hidden? ).to be true

      get unhide_comment_path( @discussion.id, @comment2.number )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: @nested.title
      expect( response.body ).to     have_css 'h2', text: @comment2.title
      expect( response.body ).not_to have_css 'i',  text: I18n.t( 'discussions.hidden_comment' )
    end
  end

  describe 'GET /admin/discussion/1/lock/1' do
    it 'locks the comment' do
      get lock_comment_path( @discussion.id, @comment2.number )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment2.reload.locked? ).to be true
    end
  end

  describe 'GET /admin/discussion/1/unlock/1' do
    it 'unlocks the comment' do
      @comment2.lock
      expect( @comment2.reload.locked? ).to be true

      get unlock_comment_path( @discussion.id, @comment2.number )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment2.reload.locked? ).to be false
    end
  end

  describe 'DELETE /admin/discussion/1/delete/1' do
    it 'removes the comment' do
      delete delete_comment_path( @discussion.id, @comment2.number )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).not_to include @comment2.title
    end
  end
end
