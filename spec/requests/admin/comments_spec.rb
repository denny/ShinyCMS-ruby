require 'rails_helper'

RSpec.describe 'Comment moderation', type: :request do
  before :each do
    @admin = create :comment_admin
    sign_in @admin

    FeatureFlag.enable :comments

    @post = create :blog_post
    @discussion = create :discussion, resource: @post

    @comment1 = create :top_level_comment, discussion: @discussion
    @comment2 = create :top_level_comment, discussion: @discussion
    create :top_level_comment, discussion: @discussion

    @nested = create :nested_comment, discussion: @discussion, parent: @comment1
  end

  # TODO: Can I use the real helper method here instead of this nasty copypasta?
  def comment_in_context_path( comment )
    if comment.blank? || comment.spam?
      return "/blog/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}#comments"
    end

    "/blog/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}##{comment.number}"
  end

  describe 'GET /admin/comments' do
    it 'fetches the spam comment moderation page' do
      get comments_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.comments.index.title' ).titlecase
    end
  end

  describe 'GET /admin/comment/hide/1' do
    it 'hides the comment' do
      get hide_comment_path( @comment2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to comment_in_context_path( @comment2 )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: @nested.title
      expect( response.body ).not_to have_css 'h2', text: @comment2.title
      expect( response.body ).to     have_css 'i',  text: I18n.t( 'discussions.hidden_comment' )
    end
  end

  describe 'GET /admin/comment/unhide/1' do
    it 'unhides the comment' do
      @comment2.hide
      expect( @comment2.hidden? ).to be true

      get unhide_comment_path( @comment2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to comment_in_context_path( @comment2 )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: @nested.title
      expect( response.body ).to     have_css 'h2', text: @comment2.title
      expect( response.body ).not_to have_css 'i',  text: I18n.t( 'discussions.hidden_comment' )
    end
  end

  describe 'GET /admin/comment/lock/1' do
    it 'locks the comment' do
      get lock_comment_path( @comment2 )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to comment_in_context_path( @comment2 )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment2.reload.locked? ).to be true
    end
  end

  describe 'GET /admin/comment/unlock/1' do
    it 'unlocks the comment' do
      @comment2.lock
      expect( @comment2.reload.locked? ).to be true

      get unlock_comment_path( @comment2 )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to comment_in_context_path( @comment2 )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment2.reload.locked? ).to be false
    end
  end

  describe 'GET /admin/comment/1/is-spam' do
    it 'marks the comment as spam' do
      get spam_comment_path( @comment2 )
      @comment2.reload

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to comment_in_context_path( @comment2 )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment2.spam? ).to be true
    end
  end

  describe 'DELETE /admin/comment/delete/1' do
    it 'removes the comment' do
      delete delete_comment_path( @comment2 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to comment_in_context_path( @comment2 )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).not_to include @comment2.title
    end
  end
end
