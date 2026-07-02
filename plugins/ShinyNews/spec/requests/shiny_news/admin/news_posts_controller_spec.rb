# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for news admin features
RSpec.describe ShinyNews::Admin::NewsPostsController, type: :request do
  let( :admin ) do
    admin = create :news_admin
    sign_in admin
    admin
  end

  before do
    admin
  end

  describe 'GET /admin/news' do
    context 'when there are no posts' do
      it "displays the 'no news posts found' message" do
        get shiny_news.news_posts_path

        pager_info = 'No news posts found'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end

    context 'when there are less than one page of posts' do
      it 'displays the list of news posts' do
        create_list :news_post, 3

        get shiny_news.news_posts_path

        pager_info = 'Displaying 3 news posts'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end

    context 'when there are more than one page of posts' do
      it 'fetches the first page' do
        create_list :news_post, 12

        get shiny_news.news_posts_path

        pager_info = 'Displaying news posts 1-10 of 12 in total'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end

      it 'fetches the second page when requested' do
        create_list :news_post, 12

        get shiny_news.news_posts_path, params: { page: 2 }

        pager_info = 'Displaying news posts 11-12 of 12 in total'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end
  end

  describe 'GET /admin/news/search?q=zing' do
    it 'fetches the list of matching news posts' do
      post1 = create :news_post, body: 'Zebras are zingy'
      post2 = create :news_post, body: 'Aardvarks are awesome'

      get shiny_news.search_news_posts_path, params: { q: 'zing' }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.index.title' ).titlecase

      expect( response.body ).to     have_css 'td', text: post1.title
      expect( response.body ).not_to have_css 'td', text: post2.title
    end
  end

  describe 'GET /admin/news/new' do
    it 'loads the form to create a new news post' do
      get shiny_news.new_news_post_path

      expect( response ).to have_http_status :ok
    end
  end

  describe 'POST /admin/news' do
    it 'creates a new news post when a complete form is submitted' do
      post shiny_news.news_posts_path, params: {
        post: {
          user_id: admin.id,
          title:   Faker::Books::CultureSeries.unique.culture_ship,
          body:    Faker::Lorem.paragraph
        }
      }

      post1 = ShinyNews::Post.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_news.edit_news_post_path( post1 )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_news.admin.news_posts.create.success' )
    end

    it 'creates a linked discussion if requested' do
      post shiny_news.news_posts_path, params: {
        post: {
          user_id:                 admin.id,
          title:                   Faker::Books::CultureSeries.unique.culture_ship,
          body:                    Faker::Lorem.paragraph,
          discussion_show_on_site: '1',
          discussion_locked:       '1'
        }
      }

      post = ShinyNews::Post.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_news.edit_news_post_path( post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_news.admin.news_posts.create.success' )

      expect( post.discussion         ).to be_present
      expect( post.discussion.hidden? ).to be false
      expect( post.discussion.locked? ).to be true
    end

    it 'fails to create a new news post when an incomplete form is submitted' do
      post shiny_news.news_posts_path, params: {
        post: {
          user_id: admin.id,
          title:   Faker::Books::CultureSeries.unique.culture_ship,
          body:    nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_news.admin.news_posts.create.failure' )
    end

    it "fails to create a new news post when the slug isn't unique this month" do
      post_from_this_month = create :news_post, posted_at: Time.zone.now.beginning_of_month

      post shiny_news.news_posts_path, params: {
        post: {
          user_id: admin.id,
          title:   Faker::Books::CultureSeries.unique.culture_ship,
          body:    Faker::Lorem.paragraph,
          slug:    post_from_this_month.slug
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_news.admin.news_posts.create.failure' )
    end

    it "doesn't fail when the slug is unique this month but not globally" do
      post_from_last_month = create :news_post, posted_at: 1.month.ago

      post shiny_news.news_posts_path, params: {
        post: {
          user_id: admin.id,
          title:   Faker::Books::CultureSeries.unique.culture_ship,
          body:    Faker::Lorem.paragraph,
          slug:    post_from_last_month.slug
        }
      }

      new_post = ShinyNews::Post.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_news.edit_news_post_path( new_post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_news.admin.news_posts.create.success' )
    end
  end

  describe 'GET /admin/news/:id/edit' do
    it 'loads the form to edit an existing news post' do
      post = create :news_post

      get shiny_news.edit_news_post_path( post )

      expect( response ).to have_http_status :ok
    end
  end

  describe 'PUT /admin/news' do
    it 'fails to update the news post when an incomplete form is submitted' do
      post = create :news_post

      put shiny_news.news_post_path( post ), params: {
        post: {
          user_id: admin.id,
          title:   Faker::Books::CultureSeries.unique.culture_ship,
          body:    nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_news.admin.news_posts.update.failure' )
    end

    it 'updates the news post when a complete form is submitted' do
      post = create :news_post

      put shiny_news.news_post_path( post ), params: {
        post: {
          user_id: admin.id,
          title:   Faker::Books::CultureSeries.unique.culture_ship,
          body:    Faker::Lorem.paragraph
        }
      }

      post = ShinyNews::Post.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_news.edit_news_post_path( post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_news.admin.news_posts.update.success' )
    end

    it 'updates the discussion hidden/locked status successfully' do
      post = create :news_post
      create :discussion, resource: post

      put shiny_news.news_post_path( post ), params: {
        post: {
          user_id:                 admin.id,
          title:                   Faker::Books::CultureSeries.unique.culture_ship,
          body:                    Faker::Lorem.paragraph,
          discussion_show_on_site: '1',
          discussion_locked:       '1'
        }
      }

      post = ShinyNews::Post.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_news.edit_news_post_path( post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_news.admin.news_posts.update.success' )
      expect( post.discussion.hidden? ).to be false
      expect( post.discussion.locked? ).to be true
    end
  end

  describe 'DELETE /admin/news/:id' do
    it 'deletes the specified news post' do
      p1 = create :news_post
      p2 = create :news_post
      p3 = create :news_post

      delete shiny_news.news_post_path( p2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_news.news_posts_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_news.admin.news_posts.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success',
                                              text: I18n.t( 'shiny_news.admin.news_posts.destroy.success' )
      expect( response.body ).to     have_css 'td', text: p1.title
      expect( response.body ).not_to have_css 'td', text: p2.title
      expect( response.body ).to     have_css 'td', text: p3.title
    end
  end
end
