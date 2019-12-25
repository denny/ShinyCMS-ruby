require 'rails_helper'

RSpec.describe 'Admin::Blog::Posts', type: :request do
  before :each do
    @blog = create :blog

    admin = create :blog_admin
    sign_in admin
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

  describe 'GET /admin/blog/posts/:id/edit' do
    it 'loads the form to edit an existing blog post' do
      post = create :blog_post, blog: @blog

      get edit_admin_blog_post_path( post )

      expect( response ).to have_http_status :ok
    end
  end
end
