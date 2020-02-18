require 'rails_helper'

RSpec.describe 'Discussions/Comments', type: :request do
  before :each do
    create :feature_flag, name: 'blogs', enabled: true

    blog = create :blog
    @post = create :blog_post, blog: blog

    discussion = create :discussion, resource: @post
    @post.update!( discussion: discussion )

    create :top_level_comment, discussion: discussion
    @comment = create :top_level_comment, discussion: discussion
    create :top_level_comment, discussion: discussion

    @nested = create :nested_comment, discussion: discussion, parent: @comment
  end

  describe 'GET /blog/1999/12/testing' do
    it 'loads a blog post and its comments' do
      get "/blog/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h3', text: I18n.t( 'discussions.comments' )
      expect( response.body ).to have_css 'h2', text: @comment.title
      expect( response.body ).to have_css 'h2', text: @nested.title
    end

    it 'does not display the content of hidden comments' do
      @comment.hide

      get "/blog/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_css 'h3', text: I18n.t( 'discussions.comments' )
      expect( response.body ).not_to have_css 'h2', text: @comment.title
      expect( response.body ).to     have_css 'h2', text: @nested.title
    end

    it 'loads a blog post with an empty discussion' do
      @post.discussion.comments.delete_all

      get "/blog/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css 'h3', text: I18n.t( 'discussions.comments' )
      expect( response.body ).to have_css 'p',  text: I18n.t( 'discussions.zero_comments' )
    end

    it 'loads a blog post with no discussion attached' do
      @post.update!( discussion: nil )

      get "/blog/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to     have_http_status :ok
      expect( response.body ).not_to have_css 'h3', text: I18n.t( 'discussions.comments' )
    end
  end
end
