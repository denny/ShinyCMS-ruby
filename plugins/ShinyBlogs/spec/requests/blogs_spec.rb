# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe 'Blogs', type: :request do
  before do
    ShinyCMS::FeatureFlag.enable :shiny_blogs
    @blog = create :shiny_blogs_blog
  end

  describe 'GET #recent' do
    it 'returns a success response' do
      post1 = create :shiny_blogs_blog_post, blog: @blog, body: <<~BODY1
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

      post2 = create :shiny_blogs_blog_post, blog: @blog, body: <<~BODY2
        Not sure about this approach
        <br><br>
        Alternative way of doing paragraphs, basically.
      BODY2

      post3 = create :shiny_blogs_blog_post, blog: @blog

      get shiny_blogs.view_blog_path( @blog.slug )

      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2',      text: post1.title
      expect( response.body ).to     have_css 'section', text: 'Third is the details'
      expect( response.body ).not_to have_css 'section', text: "shouldn't appear in the teaser!"
      expect( response.body ).to     have_css 'h2',      text: post2.title
      expect( response.body ).to     have_css 'h2',      text: post3.title
    end

    it "throws an appropriate error if the requested blog doesn't exist" do
      get shiny_blogs.view_blog_path( 'no-such-blog' )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to shiny_blogs.view_blogs_path
      follow_redirect!
      expect( response ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shiny_blogs.blogs.set_blog.failure' )
    end
  end

  describe 'GET #show' do
    it 'displays the specified blog post' do
      post = create :shiny_blogs_blog_post, blog: @blog

      # get shiny_blogs.view_blog_post_path( post )
      get "/blogs/#{@blog.slug}/#{post.posted_year}/#{post.posted_month}/#{post.slug}"

      expect( response ).to have_http_status :ok
    end

    it 'displays the 404 page if the blog post does not exist', :production_error_responses do
      post = create :shiny_blogs_blog_post, blog: @blog

      # get shiny_blogs.view_blog_post_path( post )
      get "/blogs/#{@blog.slug}/#{post.posted_year}/#{post.posted_month}/NOPE"

      expect( response ).to have_http_status :not_found
    end
  end

  describe 'GET #month' do
    it 'displays the blog posts from the specified month' do
      post1 = create :shiny_blogs_blog_post, blog: @blog, posted_at: '2000-02-20'
      post2 = create :shiny_blogs_blog_post, blog: @blog, posted_at: '2000-02-29'
      post3 = create :shiny_blogs_blog_post, blog: @blog, posted_at: '2000-09-03'

      # get shiny_blogs.view_blog_month_path( blog, year, month )
      get "/blogs/#{@blog.slug}/#{post1.posted_year}/#{post1.posted_month}"

      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2', text: 'February'
      expect( response.body ).to     have_css 'h2', text: post1.title
      expect( response.body ).to     have_css 'h2', text: post2.title
      expect( response.body ).not_to have_css 'h2', text: post3.title
    end
  end

  describe 'GET #year' do
    it 'displays the blog posts from the specified year' do
      post1 = create :shiny_blogs_blog_post, blog: @blog, posted_at: '2000-02-20'
      post2 = create :shiny_blogs_blog_post, blog: @blog, posted_at: '2000-02-29'
      post3 = create :shiny_blogs_blog_post, blog: @blog, posted_at: '2000-09-03'

      # get shiny_blogs.view_blog_year_path( blog, year )
      get "/blogs/#{@blog.slug}/#{post1.posted_year}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h2', text: 'February'
      expect( response.body ).to have_css 'h2', text: 'September'
      expect( response.body ).to have_css 'h2', text: post1.title
      expect( response.body ).to have_css 'h2', text: post2.title
      expect( response.body ).to have_css 'h2', text: post3.title
    end
  end
end
