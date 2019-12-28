require 'rails_helper'

RSpec.describe 'Blogs', type: :request do
  before :each do
    @blog = create :blog
    create :feature_flag, name: 'blogs', enabled: true
  end

  describe 'GET #recent' do
    it 'returns a success response' do
      get view_blog_path

      expect( response ).to have_http_status :ok

      # Version from scaffold controller spec
      expect( response ).to be_successful
    end

    it 'throws an appropriate error if no blog exists' do
      create :page
      Blog.all.destroy_all

      get view_blog_path

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to root_path
      follow_redirect!
      expect( response.body ).to have_css '#alerts', text: I18n.t( 'blogs.set_blog.failure' )

      # Version from scaffold controller spec
      expect( response ).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      post = create :blog_post, blog: @blog

      # get view_blog_post_path( post )
      get "/blog/#{post.posted_at.year}/#{post.posted_at.month}/#{post.slug}"

      expect( response ).to have_http_status :ok
    end
  end
end
