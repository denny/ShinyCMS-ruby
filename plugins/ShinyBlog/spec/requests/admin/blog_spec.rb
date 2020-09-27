# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe 'Admin::Blog', type: :request do
  before :each do
    @admin = create :blog_admin
    sign_in @admin
  end

  describe 'GET /admin/blog' do
    it 'fetches the list of blog posts' do
      get shiny_blog.blog_posts_path

      expect( response ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blog.admin.blog_posts.index.title' ).titlecase
    end
  end

  describe 'GET /admin/blog/new' do
    it 'loads the form to create a new blog post' do
      get shiny_blog.new_blog_post_path

      expect( response ).to have_http_status :ok
    end
  end

  describe 'POST /admin/blog' do
    it 'creates a new blog post when a complete form is submitted' do
      post shiny_blog.blog_posts_path, params: {
        post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph
        }
      }

      post1 = ShinyBlog::Post.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blog.edit_blog_post_path( post1 )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blog.admin.blog_posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_blog.admin.blog_posts.create.success' )
    end

    it 'creates a linked discussion if requested' do
      post shiny_blog.blog_posts_path, params: {
        post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph,
          discussion_show_on_site: '1',
          discussion_locked: '1'
        }
      }

      post = ShinyBlog::Post.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blog.edit_blog_post_path( post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_blog.admin.blog_posts.create.success' )

      expect( post.discussion         ).to be_present
      expect( post.discussion.hidden? ).to be false
      expect( post.discussion.locked? ).to be true
    end

    it 'fails to create a new blog post when an incomplete form is submitted' do
      post shiny_blog.blog_posts_path, params: {
        post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blog.admin.blog_posts.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_blog.admin.blog_posts.create.failure' )
    end

    it "fails to create a new blog post when the slug isn't unique this month" do
      post_from_this_month = create :blog_post, posted_at: Time.zone.now.beginning_of_month

      post shiny_blog.blog_posts_path, params: {
        post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph,
          slug: post_from_this_month.slug
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blog.admin.blog_posts.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_blog.admin.blog_posts.create.failure' )
    end

    it "doesn't fail when the slug is unique this month but not globally" do
      post_from_last_month = create :blog_post, posted_at: 1.month.ago

      post shiny_blog.blog_posts_path, params: {
        post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph,
          slug: post_from_last_month.slug
        }
      }

      new_post = ShinyBlog::Post.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blog.edit_blog_post_path( new_post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blog.admin.blog_posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_blog.admin.blog_posts.create.success' )
    end
  end

  describe 'GET /admin/blog/:id/edit' do
    it 'loads the form to edit an existing blog post' do
      post = create :blog_post

      get shiny_blog.edit_blog_post_path( post )

      expect( response ).to have_http_status :ok
    end
  end

  describe 'PUT /admin/blog' do
    it 'fails to update the blog post when an incomplete form is submitted' do
      post = create :blog_post

      put shiny_blog.blog_post_path( post ), params: {
        post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blog.admin.blog_posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_blog.admin.blog_posts.update.failure' )
    end

    it 'updates the blog post when a complete form is submitted' do
      post = create :blog_post

      put shiny_blog.blog_post_path( post ), params: {
        post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph
        }
      }

      post = ShinyBlog::Post.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blog.edit_blog_post_path( post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blog.admin.blog_posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_blog.admin.blog_posts.update.success' )
    end

    it 'updates the discussion hidden/locked status successfully' do
      post = create :blog_post
      create :discussion, resource: post

      put shiny_blog.blog_post_path( post ), params: {
        post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph,
          discussion_show_on_site: '0',
          discussion_locked: '1'
        }
      }

      post = ShinyBlog::Post.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blog.edit_blog_post_path( post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_blog.admin.blog_posts.update.success' )
      expect( post.discussion.hidden? ).to be true
      expect( post.discussion.locked? ).to be true
    end
  end

  describe 'DELETE /admin/blog/:id' do
    it 'deletes the specified blog post' do
      p1 = create :blog_post
      p2 = create :blog_post
      p3 = create :blog_post

      delete shiny_blog.blog_post_path( p2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_blog.blog_posts_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_blog.admin.blog_posts.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success',
                                              text: I18n.t( 'shiny_blog.admin.blog_posts.destroy.success' )
      expect( response.body ).to     have_css 'td', text: p1.title
      expect( response.body ).not_to have_css 'td', text: p2.title
      expect( response.body ).to     have_css 'td', text: p3.title
    end

    it 'fails gracefully when attempting to delete a non-existent blog post' do
      delete shiny_blog.blog_post_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blog.blog_posts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blog.admin.blog_posts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_blog.admin.blog_posts.set_post.not_found' )
    end
  end
end
