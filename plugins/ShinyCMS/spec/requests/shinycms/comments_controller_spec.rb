# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for discussion and comment features on main site
RSpec.describe ShinyCMS::CommentsController, type: :request do
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

  describe 'GET /discussion/1/1' do
    it 'displays a comment' do
      get shinycms.comment_path( @discussion, @comment.number )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h2', text: @comment.title
    end

    it "renders the 404 page if the comment doesn't exist", :production_error_responses do
      get shinycms.comment_path( @discussion, 999 )

      expect( response      ).to have_http_status :not_found
      expect( response.body ).to have_css 'h2', text: I18n.t(
        'shinycms.errors.not_found.title', resource_type: 'Page'
      )
    end
  end

  describe 'GET /discussion/1/from/1' do
    it 'displays a comment and all replies nested below it' do
      get shinycms.comment_thread_path( @discussion, @comment.number )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h2', text: @comment.title
      expect( response.body ).to have_css 'h2', text: @nested.title
    end
  end

  describe 'POST /discussion/1' do
    it 'adds a new top-level comment to the discussion' do
      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      post shinycms.add_comment_path( @discussion ), params: {
        comment: {
          title: title,
          body:  body
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.comments.create.success' )
      expect( response.body ).to have_css 'h2', text: title
      expect( response.body ).to include body
    end

    it 'adds a new comment by a logged-in user' do
      user = create :user
      sign_in user

      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      post shinycms.add_comment_path( @discussion ), params: {
        comment: {
          title:       title,
          body:        body,
          author_type: 'authenticated'
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.comments.create.success' )
      expect( response.body ).to have_css 'h2', text: title
      expect( response.body ).to have_css 'h3', text: user.username
    end

    it 'adds a new comment by a pseudonymous user' do
      name = Faker::Name.unique.name
      title = Faker::Books::CultureSeries.unique.culture_ship

      post shinycms.add_comment_path( @discussion ), params: {
        comment: {
          author_name:  name,
          author_email: Faker::Internet.unique.email,
          author_type:  'pseudonymous',
          title:        title,
          body:         Faker::Lorem.paragraph
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.comments.create.success' )
      expect( response.body ).to have_css 'h2', text: title
      expect( response.body ).to have_css 'h3', text: name
    end

    it 'fails to post a top-level comment with missing fields' do
      post shinycms.add_comment_path( @discussion ), params: {
        comment: {
          title: nil,
          body:  nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shinycms.comments.create.failure' )
    end

    it 'adds a new top-level comment to the discussion, with a recaptcha check' do
      allow( described_class ).to receive( :recaptcha_v3_secret_key ).and_return( 'A_KEY' )

      ShinyCMS::FeatureFlag.enable :recaptcha_for_comments

      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      post shinycms.add_comment_path( @discussion ), params: {
        comment: {
          title: title,
          body:  body
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.comments.create.success' )
      expect( response.body ).to have_css 'h2', text: title
      expect( response.body ).to include body
    end

    it 'classifies a new comment as spam after checking Akismet' do
      ShinyCMS::FeatureFlag.enable :akismet_for_comments
      akismet_client = instance_double( Akismet::Client, open: nil, check: [ true, false ] )
      allow( Akismet::Client ).to receive( :new ).and_return( akismet_client )

      always_fail_author_name = 'viagra-test-123'
      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      post shinycms.add_comment_path( @discussion ), params: {
        comment: {
          title:       title,
          body:        body,
          author_name: always_fail_author_name
        }
      }

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response ).to have_http_status :ok

      expect( ShinyCMS::Comment.last.spam ).to be true

      expect( response.body ).not_to have_css '.notices', text: I18n.t( 'shinycms.comments.create.success' )
      expect( response.body ).not_to have_css 'h2', text: title
    end

    it "doesn't save a new comment if Akismet classifies it as 'blatant' spam" do
      ShinyCMS::FeatureFlag.enable :akismet_for_comments
      akismet_client = instance_double( Akismet::Client, open: nil, check: [ true, true ] )
      allow( Akismet::Client ).to receive( :new ).and_return( akismet_client )

      name  = Faker::Name.unique.name
      email = Faker::Internet.unique.email
      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      comment_count   = ShinyCMS::Comment.count
      author_count    = ShinyCMS::PseudonymousAuthor.count
      recipient_count = ShinyCMS::EmailRecipient.count

      post shinycms.add_comment_path( @discussion ), params: {
        comment: {
          author_name:  name,
          author_email: email,
          title:        title,
          body:         body
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).not_to have_css '.notices', text: I18n.t( 'shinycms.comments.create.success' )
      expect( response.body ).not_to have_css 'h2', text: title

      expect( ShinyCMS::Comment.count            ).to eq comment_count
      expect( ShinyCMS::PseudonymousAuthor.count ).to eq author_count
      expect( ShinyCMS::EmailRecipient.count     ).to eq recipient_count
    end
  end

  describe 'POST /discussion/1/1' do
    it 'adds a new comment as a reply to an existing comment' do
      title = Faker::Books::CultureSeries.unique.culture_ship
      body  = Faker::Lorem.paragraph

      post shinycms.add_comment_path( @discussion, @comment.number ), params: {
        comment: {
          title: title,
          body:  body
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.discussion_path( @discussion )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.comments.create.success' )
      expect( response.body ).to have_css 'h2', text: title
      expect( response.body ).to include body
    end

    it 'fails to post a reply with missing fields' do
      post shinycms.add_comment_path( @discussion, @comment.number ), params: {
        comment: {
          title: nil,
          body:  nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shinycms.comments.create.failure' )
    end
  end
end
