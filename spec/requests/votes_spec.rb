# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Votes', type: :request do
  skip 'Removing news feature, to replace with plugin version'

  before :each do
    FeatureFlag.enable :news
    FeatureFlag.enable :comments

    post = create :news_post

    discussion = create :discussion, resource: post
    post.update!( discussion: discussion )

    cmntr = create :user
    create :top_level_comment, discussion: discussion
    @comment = create :top_level_comment, discussion: discussion, author: cmntr

    @voter = create :user
  end

  describe 'POST /vote/comment/1/up' do
    it 'up-votes the comment once, despite two attempts' do
      expect( @comment.get_upvotes.size ).to eq 0

      post create_vote_path( 'comment', @comment, 'up' )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to @comment.path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment.reload.get_upvotes.size ).to eq 1

      post create_vote_path( 'comment', @comment, 'up' )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to @comment.path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment.reload.get_upvotes.size ).to eq 1
    end
  end

  describe 'POST /vote/comment/1/down' do
    it 'down-votes the comment' do
      expect( @comment.get_downvotes.size ).to eq 0

      sign_in @voter
      post create_vote_path( 'comment', @comment, 'down' )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to @comment.path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment.reload.get_downvotes.size ).to eq 1
    end
  end

  describe 'DELETE /vote/comment/1' do
    it 'remotes the existing vote from the comment' do
      sign_in @voter
      @comment.upvote_by @voter
      expect( @comment.get_upvotes.size ).to eq 1

      delete destroy_vote_path( 'comment', @comment )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to @comment.path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( @comment.reload.get_upvotes.size ).to eq 0
    end
  end
end
