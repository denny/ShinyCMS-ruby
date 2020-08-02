# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Blogs', type: :request do
  before :each do
    @admin = create :blog_admin
    sign_in @admin
  end

  describe 'GET /admin/blogs' do
    it 'fetches the list of blogs' do
      get blogs_path

      expect( response ).to have_http_status :ok
    end
  end

  describe 'GET /admin/blogs/new' do
    it 'loads the form to create a new blog' do
      get new_blog_path

      expect( response ).to have_http_status :ok
    end
  end

  describe 'POST /admin/blogs' do
    it 'creates a new blog when a complete form is submitted' do
      post create_blog_path, params: {
        blog: {
          user_id: @admin.id,
          internal_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      blog = Blog.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_blog_path( blog )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blogs.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.blogs.create.success' )
    end

    it 'fails to create a new blog when an incomplete form is submitted' do
      post create_blog_path, params: {
        blog: {
          user_id: @admin.id
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blogs.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.blogs.create.failure' )
    end
  end

  describe 'GET /admin/blogs/:id/edit' do
    it 'loads the form to edit an existing blog' do
      blog = create :blog

      get edit_blog_path( blog )

      expect( response ).to have_http_status :ok
    end
  end

  describe 'PUT /admin/blogs/:id' do
    it 'updates the blog details when a complete form is submitted' do
      blog = create :blog

      put blog_path( blog ), params: {
        blog: {
          user_id: @admin.id,
          internal_name: Faker::Books::CultureSeries.unique.culture_ship
        }
      }

      blog = Blog.last

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_blog_path( blog )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blogs.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.blogs.update.success' )
    end

    it 'fails to update the blog details when invalid details are submitted' do
      blog = create :blog

      put blog_path( blog ), params: {
        blog: {
          user_id: @admin.id,
          internal_name: ''
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blogs.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.blogs.update.failure' )
    end
  end

  describe 'DELETE /admin/blogs/:id' do
    it 'deletes the specified blog' do
      b1 = create :blog
      b2 = create :blog
      b3 = create :blog

      delete blog_path( b2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to blogs_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.blogs.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.blogs.destroy.success' )
      expect( response.body ).to     have_css 'td', text: b1.internal_name
      expect( response.body ).not_to have_css 'td', text: b2.internal_name
      expect( response.body ).to     have_css 'td', text: b3.internal_name
    end

    it 'fails gracefully when attempting to delete a non-existent blog' do
      delete blog_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to blogs_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.blogs.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.blogs.destroy.failure' )
    end
  end
end
