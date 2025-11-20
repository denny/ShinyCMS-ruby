# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for discussion and comment features on main site
RSpec.describe ShinyCMS::DiscussionsController, type: :request do
  before do
    ShinyCMS::FeatureFlag.enable :news
    ShinyCMS::FeatureFlag.enable :comments

    ShinyCMS::FeatureFlag.disable :recaptcha_for_comments
    ShinyCMS::FeatureFlag.disable :akismet_for_comments

    @post = create :news_post

    @discussion = create :discussion, resource: @post
    @post.update!( discussion: @discussion )

    cmntr = create :user
    create :top_level_comment, discussion: @discussion
    @comment = create :top_level_comment, discussion: @discussion, author: cmntr
    create :top_level_comment, discussion: @discussion

    @nested = create :nested_comment, discussion: @discussion, parent: @comment
  end

  describe 'GET /discussions' do
    it 'displays the current most active discussions' do
      get shinycms.discussions_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.discussions.index.title' )
      expect( response.body ).to have_css 'h2', text: I18n.t( 'shinycms.discussions.index.recently_active' )
    end
  end

  describe 'GET /news/1999/12/testing' do
    it 'loads a news post and its comments' do
      get "/news/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h3', text: I18n.t( 'shinycms.discussions.comments' )
      expect( response.body ).to have_css 'h2', text: @comment.title
      expect( response.body ).to have_css 'h2', text: @nested.title
    end

    it 'loads a news post with an empty discussion' do
      @discussion.comments.delete_all

      get "/news/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h3', text: I18n.t( 'shinycms.discussions.comments' )
      expect( response.body ).to have_css 'p',  text: I18n.t( 'shinycms.empty_list', items: 'comments' )
    end

    it 'loads a news post with no discussion attached' do
      @post.update!( discussion: nil )

      get "/news/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to     have_http_status :ok
      expect( response.body ).not_to have_css 'h3', text: I18n.t( 'shinycms.discussions.comments' )
    end
  end

  describe 'GET /discussion/1' do
    it 'displays a discussion, without its parent resource' do
      get shinycms.discussion_path( @discussion )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h2', text: @comment.title
      expect( response.body ).to have_css 'h2', text: @nested.title
    end

    it "renders the 404 page if the discussion doesn't exist", :production_error_responses do
      get shinycms.discussion_path( 999 )

      expect( response      ).to have_http_status :not_found
      expect( response.body ).to have_css 'h2', text: I18n.t(
        'shinycms.errors.not_found.title', resource_type: 'Discussion'
      )
    end
  end
end
