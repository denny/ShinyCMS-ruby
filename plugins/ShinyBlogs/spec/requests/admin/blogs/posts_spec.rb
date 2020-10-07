# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for blog post admin features - ShinyBlogs plugin for ShinyCMS
RSpec.describe 'Admin: Blog Posts', type: :request do
  before :each do
    @blog = create :shiny_blogs_blog

    @admin = create :single_blog_admin
    sign_in @admin
  end

  describe 'GET /admin/blogs/:blog_id' do
    it 'fetches the list of blog posts' do
      get shiny_blogs.blog_posts_path( @blog )

      expect( response ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blogs.admin.posts.index.title' ).titlecase
    end
  end

  describe 'GET /admin/blogs/:blog_id/posts/new' do
    it 'loads the form to create a new blog post' do
      get shiny_blogs.new_blog_post_path( @blog )

      expect( response ).to have_http_status :ok
    end
  end

  describe 'POST /admin/blogs/:blog_id/posts' do
    it 'creates a new blog post when a complete form is submitted' do
      post shiny_blogs.blog_posts_path( @blog ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph
        }
      }

      post = ShinyBlogs::BlogPost.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blogs.edit_blog_post_path( @blog, post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blogs.admin.posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success',
                                          text: I18n.t( 'shiny_blogs.admin.posts.create.success' )
    end

    it 'fails to create a new blog post when an incomplete form is submitted' do
      post shiny_blogs.blog_posts_path( @blog ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blogs.admin.posts.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_blogs.admin.posts.create.failure' )
    end

    it "fails to create a new blog post when the slug isn't unique this month" do
      post_from_this_month = create :shiny_blogs_blog_post, posted_at: Time.zone.now.beginning_of_month

      post shiny_blogs.blog_posts_path( @blog ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph,
          slug: post_from_this_month.slug
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blogs.admin.posts.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_blogs.admin.posts.create.failure' )
    end

    it "doesn't fail when the slug is unique this month but not globally" do
      post_from_last_month = create :shiny_blogs_blog_post, posted_at: 1.month.ago

      post shiny_blogs.blog_posts_path( @blog ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph,
          slug: post_from_last_month.slug
        }
      }

      new_post = ShinyBlogs::BlogPost.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blogs.edit_blog_post_path( @blog, new_post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blogs.admin.posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success',
                                          text: I18n.t( 'shiny_blogs.admin.posts.create.success' )
    end
  end

  describe 'GET /admin/blogs/:blog_id/posts/:id/edit' do
    it 'loads the form to edit an existing blog post' do
      post = create :shiny_blogs_blog_post, blog: @blog

      get shiny_blogs.edit_blog_post_path( @blog, post )

      expect( response ).to have_http_status :ok
    end
  end

  describe 'PUT /admin/blogs/:blog_id/posts/:id' do
    it 'fails to update the blog post when an incomplete form is submitted' do
      post = create :shiny_blogs_blog_post, blog: @blog

      put shiny_blogs.blog_post_path( @blog, post ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blogs.admin.posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_blogs.admin.posts.update.failure' )
    end

    it 'updates the blog post when a complete form is submitted' do
      post = create :shiny_blogs_blog_post, blog: @blog

      put shiny_blogs.blog_post_path( @blog, post ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph
        }
      }

      post = ShinyBlogs::BlogPost.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blogs.edit_blog_post_path( @blog, post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blogs.admin.posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success',
                                          text: I18n.t( 'shiny_blogs.admin.posts.update.success' )
    end

    it 'updates the discussion hidden/locked status successfully' do
      post = create :shiny_blogs_blog_post, blog: @blog
      create :discussion, resource: post

      put shiny_blogs.blog_post_path( @blog, post ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Books::CultureSeries.unique.culture_ship,
          body: Faker::Lorem.paragraph,
          discussion_show_on_site: true,
          discussion_locked: true
        }
      }

      post = ShinyBlogs::BlogPost.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blogs.edit_blog_post_path( @blog, post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alert-success',
                                          text: I18n.t( 'shiny_blogs.admin.posts.update.success' )
      expect( post.discussion.hidden? ).to be false
      expect( post.discussion.locked? ).to be true
    end
  end

  describe 'DELETE /admin/blogs/:blog_id/posts/:id' do
    it 'deletes the specified blog post' do
      p1 = create :shiny_blogs_blog_post, blog: @blog
      p2 = create :shiny_blogs_blog_post, blog: @blog
      p3 = create :shiny_blogs_blog_post, blog: @blog

      delete shiny_blogs.blog_post_path( @blog, p2 )

      success_message = I18n.t( 'shiny_blogs.admin.posts.destroy.success' )
      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_blogs.blog_posts_path( @blog )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_blogs.admin.posts.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: success_message
      expect( response.body ).to     have_css 'td', text: p1.title
      expect( response.body ).not_to have_css 'td', text: p2.title
      expect( response.body ).to     have_css 'td', text: p3.title
    end

    it 'fails gracefully when attempting to delete a non-existent blog post' do
      delete shiny_blogs.blog_post_path( @blog, 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_blogs.blog_posts_path( @blog )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_blogs.admin.posts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger',
                                          text: I18n.t( 'shiny_blogs.admin.posts.destroy.failure' )
    end
  end
end
