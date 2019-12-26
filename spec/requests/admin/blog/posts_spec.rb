require 'rails_helper'

RSpec.describe 'Admin::Blog::Posts', type: :request do
  before :each do
    @blog = create :blog

    @admin = create :blog_admin
    sign_in @admin
  end

  describe 'GET /admin/blog/posts' do
    it 'fetches the list of blog posts' do
      get admin_blog_posts_path

      expect( response ).to have_http_status :ok
    end
  end

  describe 'GET /admin/blog/posts/new' do
    it 'loads the form to create a new blog post' do
      get new_admin_blog_post_path

      expect( response ).to have_http_status :ok
    end
  end

  describe 'POST /admin/blog/posts' do
    it 'fails to create a new blog post when an incomplete form is submitted' do
      post admin_blog_posts_path, params: {
        blog_post: {
          blog_id: @blog.id,
          user_id: @admin.id,
          title: Faker::Science.unique.scientist,
          body: nil
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to new_admin_blog_post_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blog.posts.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.blog.posts.create.failure' )
    end

    it 'creates a new blog post when a complete form is submitted' do
      post admin_blog_posts_path, params: {
        blog_post: {
          blog_id: @blog.id,
          user_id: @admin.id,
          title: Faker::Science.unique.scientist,
          body: Faker::Lorem.paragraph
        }
      }

      post = BlogPost.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_admin_blog_post_path( post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blog.posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.blog.posts.create.success' )
    end
  end

  describe 'GET /admin/blog/posts/:id/edit' do
    it 'loads the form to edit an existing blog post' do
      post = create :blog_post, blog: @blog

      get edit_admin_blog_post_path( post )

      expect( response ).to have_http_status :ok
    end
  end

  describe 'POST /admin/blog/posts' do
    it 'fails to update the blog post when an incomplete form is submitted' do
      post = create :blog_post, blog: @blog

      put admin_blog_post_path( post ), params: {
        blog_post: {
          blog_id: @blog.id,
          user_id: @admin.id,
          title: Faker::Science.unique.scientist,
          body: nil
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_admin_blog_post_path( post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blog.posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.blog.posts.update.failure' )
    end

    it 'creates a new blog post when a complete form is submitted' do
      post = create :blog_post, blog: @blog

      put admin_blog_post_path( post ), params: {
        blog_post: {
          blog_id: @blog.id,
          user_id: @admin.id,
          title: Faker::Science.unique.scientist,
          body: Faker::Lorem.paragraph
        }
      }

      post = BlogPost.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_admin_blog_post_path( post )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blog.posts.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.blog.posts.update.success' )
    end
  end
end
