# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the up/down vote features on the main site (powered by ActsAsVotable)
RSpec.describe ShinyCMS::VotesController, type: :request do
  before do
    ShinyCMS::FeatureFlag.enable :news
    ShinyCMS::FeatureFlag.enable :comments
  end

  let( :author  ) { create :user                                                   }
  let( :voter   ) { create :user                                                   }
  let( :news    ) { create :news_post                                              }
  let( :discuss ) { create :discussion, resource: news                             }
  let( :comment ) { create :top_level_comment, discussion: discuss, author: author }

  describe 'POST /vote/comment/1/up' do
    it 'up-votes the comment once, despite two attempts' do
      expect( comment.get_upvotes.size ).to eq 0

      post shinycms.create_vote_path( comment.class.name_to_url_param, comment, 'up' )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to comment.path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( comment.reload.get_upvotes.size ).to eq 1

      post shinycms.create_vote_path( comment.class.name_to_url_param, comment, 'up' )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to comment.path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( comment.reload.get_upvotes.size ).to eq 1
    end
  end

  describe 'POST /vote/comment/1/down' do
    it 'down-votes the comment' do
      expect( comment.get_downvotes.size ).to eq 0

      sign_in voter
      post shinycms.create_vote_path( comment.class.name_to_url_param, comment, 'down' )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to comment.path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( comment.reload.get_downvotes.size ).to eq 1
    end
  end

  describe 'DELETE /vote/comment/1' do
    it 'removes the existing vote from the comment' do
      sign_in voter
      comment.upvote_by voter
      expect( comment.get_upvotes.size ).to eq 1

      delete shinycms.destroy_vote_path( comment.class.name_to_url_param, comment )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to comment.path
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( comment.reload.get_upvotes.size ).to eq 0
    end
  end
end
