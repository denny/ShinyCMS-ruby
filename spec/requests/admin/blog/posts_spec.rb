# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Blog::Posts', type: :request do
  before :each do
    @blog = create :blog

    @admin = create :blog_admin
    sign_in @admin
  end

  describe 'GET /admin/blog/1/posts' do
    it 'fetches the list of blog posts' do
      get blog_posts_path( @blog )

      expect( response ).to have_http_status :ok
    end
  end

  describe 'GET /admin/blog/1/posts/new' do
    it 'loads the form to create a new blog post' do
      get new_blog_post_path( @blog )

      expect( response ).to have_http_status :ok
    end
  end

  describe 'POST /admin/blog/1/post' do
    it 'fails to create a new blog post when an incomplete form is submitted' do
      post create_blog_post_path( @blog ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Science.unique.scientist,
          body: nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blog.posts.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.blog.posts.create.failure' )
    end

    it "fails to create a new blog post when the slug isn't unique this month" do
      item = create :blog_post

      post create_blog_post_path( @blog ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Science.unique.scientist,
          body: Faker::Lorem.paragraph,
          posted_at: item.posted_at.beginning_of_month,
          slug: item.slug
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blog.posts.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.blog.posts.create.failure' )
    end

    it 'creates a new blog post when a complete form is submitted' do
      post create_blog_post_path( @blog ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Science.unique.scientist,
          body: Faker::Lorem.paragraph
        }
      }

      post = BlogPost.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_blog_post_path( @blog, post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blog.posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.blog.posts.create.success' )
    end
  end

  describe 'GET /admin/blog/1/posts/:id/edit' do
    it 'loads the form to edit an existing blog post' do
      post = create :blog_post, blog: @blog

      get edit_blog_post_path( @blog, post )

      expect( response ).to have_http_status :ok
    end
  end

  describe 'PUT /admin/blog/1/posts' do
    it 'fails to update the blog post when an incomplete form is submitted' do
      post = create :blog_post, blog: @blog

      put blog_post_path( @blog, post ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Science.unique.scientist,
          body: nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blog.posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.blog.posts.update.failure' )
    end

    it 'updates the blog post when a complete form is submitted' do
      post = create :blog_post, blog: @blog

      put blog_post_path( @blog, post ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Science.unique.scientist,
          body: Faker::Lorem.paragraph
        }
      }

      post = BlogPost.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_blog_post_path( @blog, post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blog.posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.blog.posts.update.success' )
    end

    it 'updates the discussion hidden/locked status successfully' do
      post = create :blog_post, blog: @blog
      create :discussion, resource: post

      put blog_post_path( @blog, post ), params: {
        blog_post: {
          user_id: @admin.id,
          title: Faker::Science.unique.scientist,
          body: Faker::Lorem.paragraph,
          discussion_hidden: true,
          discussion_locked: true
        }
      }

      post = BlogPost.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_blog_post_path( @blog, post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.blog.posts.update.success' )
      expect( post.discussion.hidden ).to be true
      expect( post.discussion.locked ).to be true
    end
  end

  describe 'DELETE /admin/blog/1/posts/:id' do
    it 'deletes the specified blog post' do
      p1 = create :blog_post, blog: @blog
      p2 = create :blog_post, blog: @blog
      p3 = create :blog_post, blog: @blog

      delete blog_post_path( @blog, p2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to blog_posts_path( @blog )
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.blog.posts.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.blog.posts.destroy.success' )
      expect( response.body ).to     have_css 'td', text: p1.title
      expect( response.body ).not_to have_css 'td', text: p2.title
      expect( response.body ).to     have_css 'td', text: p3.title
    end

    it 'fails gracefully when attempting to delete a non-existent blog post' do
      delete blog_post_path( @blog, 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to blog_posts_path( @blog )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blog.posts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.blog.posts.destroy.failure' )
    end
  end
end
