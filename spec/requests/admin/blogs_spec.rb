require 'rails_helper'

RSpec.describe 'Admin::Blogs', type: :request do
  before :each do
    create :blog

    admin = create :blog_admin
    sign_in admin
  end

  describe 'GET /admin/blogs' do
    it 'fetches the list of blogs' do
      get admin_blogs_path

      expect( response ).to have_http_status :ok
    end
  end

  describe 'GET /admin/blogs/new' do
    it 'loads the form to create a new blog' do
      get new_admin_blog_path

      expect( response ).to have_http_status :ok
    end
  end

  describe 'GET /admin/blogs/:id/edit' do
    it 'loads the form to edit an existing blog' do
      blog = create :blog

      get edit_admin_blog_path( blog )

      expect( response ).to have_http_status :ok
    end
  end
end
