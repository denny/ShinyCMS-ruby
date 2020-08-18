# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Blog', type: :request do
  before :each do
    FeatureFlag.enable :blog
  end

  describe 'GET /blog' do
    it 'displays the most recent blog posts' do
      post1 = create :blog_post, body: <<~BODY1
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

      post2 = create :blog_post, body: <<~BODY2
        Not sure about this approach
        <br><br>
        Alternative way of doing paragraphs, basically.
      BODY2

      post3 = create :blog_post

      get shiny_blog.view_blog_path

      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2',      text: post1.title
      expect( response.body ).to     have_css 'section', text: 'Third is the details'
      expect( response.body ).not_to have_css 'section', text: "shouldn't appear in the teaser!"
      expect( response.body ).to     have_css 'h2',      text: post2.title
      expect( response.body ).to     have_css 'h2',      text: post3.title
    end

    it 'throws an appropriate error if no blog exists' do
      create :top_level_page
      ShinyBlog::Post.all.destroy_all

      get shiny_blog.view_blog_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'p', text: I18n.t( 'shiny_blog.blog.index.empty' )
    end
  end

  describe 'GET /blog/1999/12/a-blog-post' do
    it 'displays the specified post' do
      post = create :blog_post

      # get shiny_blog.view_blog_post_path( post )
      get "/blog/#{post.posted_year}/#{post.posted_month}/#{post.slug}"

      expect( response ).to have_http_status :ok
    end

    it "displays the 404 page if the post doesn't exist" do
      post = create :blog_post

      # get shiny_blog.view_blog_post_path( post )
      get "/blog/#{post.posted_year}/#{post.posted_month}/NOPE"

      expect( response ).to have_http_status :not_found
    end
  end

  describe 'GET /blog/1999/12' do
    it 'displays the posts for the specified month' do
      post1 = create :blog_post, posted_at: '2000-02-20'
      post2 = create :blog_post, posted_at: '2000-02-29'
      post3 = create :blog_post, posted_at: '2000-09-03'

      # get shiny_blog.view_blog_month_path( blog, year, month )
      get "/blog/#{post1.posted_year}/#{post1.posted_month}"

      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: 'February'
      expect( response.body ).to     have_css 'h2', text: post1.title
      expect( response.body ).to     have_css 'h2', text: post2.title
      expect( response.body ).not_to have_css 'h2', text: post3.title
    end
  end

  describe 'GET /blog/1999' do
    it 'displays the posts for the specified year' do
      post1 = create :blog_post, posted_at: '2000-02-20'
      post2 = create :blog_post, posted_at: '2000-02-29'
      post3 = create :blog_post, posted_at: '2000-09-03'

      # get shiny_blog.view_blog_year_path( blog, year )
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
