# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comment moderation', type: :request do
  before :each do
    @admin = create :discussion_admin
    sign_in @admin

    FeatureFlag.enable :blogs
    FeatureFlag.enable :news
    FeatureFlag.enable :comments

    @blog = create :blog_post
    @news = create :news_post

    @discussion1 = create :discussion, resource: @blog
    @comment1 = create :top_level_comment, discussion: @discussion1
    @nested1 = create :nested_comment, discussion: @discussion1, parent: @comment1
    create :top_level_comment, discussion: @discussion1

    @discussion2 = create :discussion, resource: @news
    @comment2 = create :top_level_comment, discussion: @discussion2
  end

  # TODO: Can I use the real helper method here instead of this nasty copypasta?
  def comment_in_context_path( comment )
    post = comment.discussion.resource
    type = 'blog'
    type = 'news' if comment.discussion.resource_type == 'NewsPost'

    if comment.blank? || comment.spam?
      return "/#{type}/#{post.posted_year}/#{post.posted_month}/#{post.slug}#comments"
    end

    "/#{type}/#{post.posted_year}/#{post.posted_month}/#{post.slug}##{comment.number}"
  end

  describe 'GET /admin/comments' do
    it 'fetches the spam comment moderation page' do
      get comments_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.comments.index.title' ).titlecase
    end
  end

  describe 'PUT /admin/comments' do
    it 'reminds you that you need to select spam or not spam, if you do neither' do
      put comments_path, params: {}

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to comments_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.comments.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-danger', text: I18n.t( 'admin.comments.update.spam_or_ham' )
    end

    it 'deletes the selected comments if you say they are spam' do
      @nested1.mark_as_spam
      @comment2.mark_as_spam
      expect( @nested1.reload.spam?  ).to be true
      expect( @comment2.reload.spam? ).to be true

      put comments_path, params: {
        'spam_comments[spam_or_ham]': 'spam',
        "spam_comments[comment_#{@nested1.id}]": 1,
        "spam_comments[comment_#{@comment2.id}]": 0
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to comments_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.comments.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.comments.process_spam_comments.success' )
      expect( response.body ).to     have_css 'td', text: @comment2.title
      expect( response.body ).not_to have_css 'td', text: @nested1.title

      expect( Comment.where( id: @nested1.id ) ).to be_blank
      expect( @comment2.reload.spam? ).to be true
    end

    it 'removes spam flags from the selected comments if you say they are not spam' do
      @nested1.mark_as_spam
      @comment2.mark_as_spam
      expect( @nested1.reload.spam?  ).to be true
      expect( @comment2.reload.spam? ).to be true

      put comments_path, params: {
        'spam_comments[spam_or_ham]': 'ham',
        "spam_comments[comment_#{@nested1.id}]": 1,
        "spam_comments[comment_#{@comment2.id}]": 0
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to comments_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.comments.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.comments.process_ham_comments.success' )
      expect( response.body ).to     have_css 'td', text: @comment2.title
      expect( response.body ).not_to have_css 'td', text: @nested1.title

      expect( @nested1.reload.spam?  ).to be false
      expect( @comment2.reload.spam? ).to be true
    end
  end

  describe 'GET /admin/comment/hide/1' do
    it 'hides the comment' do
      get hide_comment_path( @comment1 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to comment_in_context_path( @comment1 )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: @nested1.title
      expect( response.body ).not_to have_css 'h2', text: @comment1.title
      expect( response.body ).to     have_css 'i',  text: I18n.t( 'discussions.hidden_comment' )
    end
  end

  describe 'GET /admin/comment/unhide/1' do
    it 'unhides the comment' do
      @comment1.hide
      expect( @comment1.hidden? ).to be true

      get unhide_comment_path( @comment1 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to comment_in_context_path( @comment1 )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: @nested1.title
      expect( response.body ).to     have_css 'h2', text: @comment1.title
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
      get spam_comment_path( @comment1 )
      @comment1.reload

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to comment_in_context_path( @comment1 )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment1.spam? ).to be true
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
