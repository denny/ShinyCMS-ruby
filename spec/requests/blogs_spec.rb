require 'rails_helper'

# Note: these tests all assume single blog mode, currently.

RSpec.describe 'Blogs', type: :request do
  before :each do
    @blog = create :blog
    create :feature_flag, name: 'blogs', enabled: true
  end

  describe 'GET #recent' do
    it 'returns a success response' do
      post1 = create :blog_post, blog: @blog, body: <<~BODY1
        <p>
          First paragraph is the hook...
        </p>

        <p>
          Second is the intro...
        </p>

        <p>
          Third is the details...
        </p>

        <p>
          Fourth shouldn't appear in the teaser!
        </p>
      BODY1

      post2 = create :blog_post, blog: @blog, body: <<~BODY2
        Not sure about this approach
        <br><br>
        Alternative way of doing paragraphs, basically.
      BODY2

      post3 = create :blog_post, blog: @blog

      get view_blog_path

      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2',      text: post1.title
      expect( response.body ).to     have_css 'section', text: 'Third is the details'
      expect( response.body ).not_to have_css 'section', text: "shouldn't appear in the teaser!"
      expect( response.body ).to     have_css 'h2',      text: post2.title
      expect( response.body ).to     have_css 'h2',      text: post3.title
    end

    it 'throws an appropriate error if no blog exists' do
      create :page
      Blog.all.destroy_all

      get view_blog_path

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to root_path
      follow_redirect!
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'blogs.set_blog.failure' )
    end
  end

  describe 'GET #show' do
    it 'displays the specified blog post' do
      post = create :blog_post, blog: @blog

      # get view_blog_post_path( post )
      get "/blog/#{post.posted_year}/#{post.posted_month}/#{post.slug}"

      expect( response ).to have_http_status :ok
    end

    it 'displays the 404 page if the blog post does not exist' do
      post = create :blog_post, blog: @blog

      get "/blog/#{post.posted_year}/#{post.posted_month}/NOPE"

      expect( response ).to have_http_status :not_found
    end
  end

  describe 'GET #month' do
    it 'displays the blog posts from the specified month' do
      post1 = create :blog_post, blog: @blog, posted_at: '2000-02-20'
      post2 = create :blog_post, blog: @blog, posted_at: '2000-02-29'
      post3 = create :blog_post, blog: @blog, posted_at: '2000-09-03'

      # get view_blog_month_path( blog, year, month )
      get "/blog/#{post1.posted_year}/#{post1.posted_month}"

      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: 'February'
      expect( response.body ).to     have_css 'h2', text: post1.title
      expect( response.body ).to     have_css 'h2', text: post2.title
      expect( response.body ).not_to have_css 'h2', text: post3.title
    end
  end

  describe 'GET #year' do
    it 'displays the blog posts from the specified year' do
      post1 = create :blog_post, blog: @blog, posted_at: '2000-02-20'
      post2 = create :blog_post, blog: @blog, posted_at: '2000-02-29'
      post3 = create :blog_post, blog: @blog, posted_at: '2000-09-03'

      # get view_blog_year_path( blog, year )
      get "/blog/#{post1.posted_year}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h2', text: 'February'
      expect( response.body ).to have_css 'h2', text: 'September'
      expect( response.body ).to have_css 'h2', text: post1.title
      expect( response.body ).to have_css 'h2', text: post2.title
      expect( response.body ).to have_css 'h2', text: post3.title
    end
  end
end
