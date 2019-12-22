require 'rails_helper'

RSpec.describe 'Blogs', type: :request do
  before :each do
    @blog = create :blog
    create :feature_flag, name: 'blogs', enabled: true
  end

  describe 'GET #recent' do
    it 'returns a success response' do
      get blog_path

      expect( response ).to have_http_status :ok

      # Version from scaffold controller spec
      expect( response ).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      post = create :blog_post, blog: @blog

      get "/blog/#{post.posted_at.year}/#{post.posted_at.month}/#{post.slug}"

      expect( response ).to have_http_status :ok
    end
  end
end
