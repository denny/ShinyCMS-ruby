# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyNews::NewsController, type: :request do
  before do
    ShinyCMS::FeatureFlag.enable :news
  end

  describe 'GET /news' do
    it 'displays the most recent news posts' do
      post1 = create :news_post, body: <<~BODY1
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

      post2 = create :news_post, body: <<~BODY2
        Not sure about this approach
        <br><br>
        Alternative way of doing paragraphs, basically.
      BODY2

      post3 = create :news_post

      get shiny_news.view_news_path

      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h2',      text: post1.title
      expect( response.body ).to     have_css 'section', text: 'Third is the details'
      expect( response.body ).not_to have_css 'section', text: "shouldn't appear in the teaser!"
      expect( response.body ).to     have_css 'h2',      text: post2.title
      expect( response.body ).to     have_css 'h2',      text: post3.title
    end

    it 'throws an appropriate error if no news exists' do
      create :top_level_page
      ShinyNews::Post.destroy_all

      get shiny_news.view_news_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'p', text: I18n.t( 'shinycms.empty_list', items: 'news posts' )
    end
  end

  describe 'GET /news/1999/12/a-news-post' do
    it 'displays the specified post' do
      post = create :news_post

      # get shiny_news.view_news_post_path( post )
      get "/news/#{post.posted_year}/#{post.posted_month}/#{post.slug}"

      expect( response ).to have_http_status :ok
    end

    it "displays the 404 page if the post doesn't exist", :production_error_responses do
      post = create :news_post

      # get shiny_news.view_news_post_path( post )
      get "/news/#{post.posted_year}/#{post.posted_month}/NOPE"

      expect( response ).to have_http_status :not_found
    end
  end

  describe 'GET /news/1999/12' do
    it 'displays the posts for the specified month' do
      post1 = create :news_post, posted_at: '2000-02-20'
      post2 = create :news_post, posted_at: '2000-02-29'
      post3 = create :news_post, posted_at: '2000-09-03'

      # get shiny_news.view_news_month_path( news, year, month )
      get "/news/#{post1.posted_year}/#{post1.posted_month}"

      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title 'February'
      expect( response.body ).to     have_css 'h2', text: post1.title
      expect( response.body ).to     have_css 'h2', text: post2.title
      expect( response.body ).not_to have_css 'h2', text: post3.title
    end
  end

  describe 'GET /news/1999' do
    it 'displays the posts for the specified year' do
      post1 = create :news_post, posted_at: '2000-02-20'
      post2 = create :news_post, posted_at: '2000-02-29'
      post3 = create :news_post, posted_at: '2000-09-03'

      # get shiny_news.view_news_year_path( news, year )
      get "/news/#{post1.posted_year}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h2', text: 'February'
      expect( response.body ).to have_css 'h2', text: 'September'
      expect( response.body ).to have_css 'h2', text: post1.title
      expect( response.body ).to have_css 'h2', text: post2.title
      expect( response.body ).to have_css 'h2', text: post3.title
    end
  end

  it_behaves_like 'Paging', 'news_post', '/news', 'h2', 'title'
end
