# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::News', type: :request do
  before :each do
    @admin = create :news_admin
    sign_in @admin
  end

  describe 'GET /admin/news' do
    it 'fetches the list of news posts' do
      get shiny_news.news_posts_path

      expect( response ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.index.title' ).titlecase
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
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph
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

    it 'fails to create a new news post when an incomplete form is submitted' do
      post shiny_news.news_posts_path, params: {
        post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: nil
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
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph,
          slug: post_from_this_month.slug
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
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph,
          slug: post_from_last_month.slug
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
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: nil
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
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph
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
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph,
          discussion_show_on_site: true,
          discussion_locked: true
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

    it 'fails gracefully when attempting to delete a non-existent news post' do
      delete shiny_news.news_post_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_news.news_posts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_news.admin.news_posts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_news.admin.news_posts.set_post.not_found' )
    end
  end
end
