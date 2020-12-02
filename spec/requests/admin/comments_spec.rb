# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for admin/moderation features for individual comments
RSpec.describe Admin::CommentsController, type: :request do
  before :each do
    admin = create :discussion_admin
    sign_in admin

    FeatureFlag.enable :blog
    FeatureFlag.enable :news
    FeatureFlag.enable :comments

    blog = create :blog_post
    @news = create :news_post

    discussion1 = create :discussion, resource: blog
    @comment1 = create :top_level_comment, discussion: discussion1
    @nested1 = create :nested_comment, discussion: discussion1, parent: @comment1
    create :top_level_comment, discussion: discussion1

    discussion2 = create :discussion, resource: @news
    @comment2 = create :top_level_comment, discussion: discussion2

    WebMock.disable!
  end

  describe 'GET /admin/comments' do
    it 'fetches the spam comment moderation page' do
      create :comment, spam: true
      create :comment, spam: true
      comment3 = create :comment, spam: true

      get comments_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.comments.index.title' ).titlecase
      expect( response.body ).to have_css 'td', text: comment3.title
    end

    describe 'GET /admin/comments/search?q=zing' do
      it 'fetches the list of matching spam comments' do
        comment1 = create :comment, body: 'Zebras are zingy', spam: true
        comment2 = create :comment, body: 'Aardvarks are awesome', spam: true

        get search_comments_path, params: { q: 'zing' }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.comments.index.title' ).titlecase

        expect( response.body ).to     have_css 'td', text: comment1.title
        expect( response.body ).not_to have_css 'td', text: comment2.title
      end
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
      allow_any_instance_of( Akismet::Client ).to receive( :open )
      allow_any_instance_of( Akismet::Client ).to receive( :spam ).and_return( true )

      @nested1.mark_as_spam
      @comment2.mark_as_spam
      expect( @nested1.reload.spam?  ).to be true
      expect( @comment2.reload.spam? ).to be true

      put comments_path, params: {
        spam_or_ham: 'spam',
        spam_comments: {
          "comment_#{@nested1.id}": 1,
          "comment_#{@comment2.id}": 0
        }
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
      allow_any_instance_of( Akismet::Client ).to receive( :open )
      allow_any_instance_of( Akismet::Client ).to receive( :ham  ).and_return( true )

      @nested1.mark_as_spam
      @comment2.mark_as_spam
      expect( @nested1.reload.spam?  ).to be true
      expect( @comment2.reload.spam? ).to be true

      put comments_path, params: {
        spam_or_ham: 'ham',
        spam_comments: {
          "comment_#{@nested1.id}": 1,
          "comment_#{@comment2.id}": 0
        }
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

    it 'reports an error if it fails to remove spam flags' do
      allow_any_instance_of( Akismet::Client ).to receive( :open )
      allow_any_instance_of( Akismet::Client ).to receive( :ham  ).and_return( true )
      allow( Comment ).to receive( :mark_all_as_ham ).and_return( false )

      @nested1.mark_as_spam
      @comment2.mark_as_spam

      put comments_path, params: {
        spam_or_ham: 'ham',
        spam_comments: {
          "comment_#{@nested1.id}": 1,
          "comment_#{@comment2.id}": 0
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to comments_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.comments.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.comments.process_ham_comments.failure' )
    end
  end

  describe 'PUT /admin/comment/1/hide' do
    it 'hides the comment' do
      put hide_comment_path( @comment1 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to @comment1.anchored_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: @nested1.title
      expect( response.body ).not_to have_css 'h2', text: @comment1.title
      expect( response.body ).to     have_css 'i',  text: I18n.t( 'discussions.hidden_comment' )
    end
  end

  describe 'PUT /admin/comment/1/show' do
    it 'unhides the comment' do
      @comment1.hide
      expect( @comment1.hidden? ).to be true

      put show_comment_path( @comment1 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to @comment1.anchored_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: @nested1.title
      expect( response.body ).to     have_css 'h2', text: @comment1.title
      expect( response.body ).not_to have_css 'i',  text: I18n.t( 'discussions.hidden_comment' )
    end
  end

  describe 'PUT /admin/comment/1/lock' do
    it 'locks the comment' do
      put lock_comment_path( @comment2 )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to @comment2.anchored_path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment2.reload.locked? ).to be true
    end
  end

  describe 'PUT /admin/comment/1/unlock' do
    it 'unlocks the comment' do
      @comment2.lock
      expect( @comment2.reload.locked? ).to be true

      put unlock_comment_path( @comment2 )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to @comment2.anchored_path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment2.reload.locked? ).to be false
    end
  end

  describe 'PUT /admin/comment/1/is-spam' do
    it 'marks the comment as spam' do
      put spam_comment_path( @comment1 )
      @comment1.reload

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to @comment1.anchored_path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment1.spam? ).to be true
    end
  end

  describe 'DELETE /admin/comment/1/delete' do
    it 'removes the comment' do
      delete destroy_comment_path( @comment2 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to @news.path( anchor: 'comments' )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).not_to have_css 'td', text: @comment2.title
    end
  end
end
