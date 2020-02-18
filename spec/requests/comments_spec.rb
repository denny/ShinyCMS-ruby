require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  before :each do
    create :feature_flag, name: 'blogs', enabled: true

    blog = create :blog
    @post = create :blog_post, blog: blog

    discussion = create :discussion, resource: @post
    @post.update!( discussion: discussion )

    create :top_level_comment, discussion: discussion
    comment = create :top_level_comment, discussion: discussion
    create :top_level_comment, discussion: discussion

    create :nested_comment, discussion: discussion, parent: comment
  end

  describe 'GET /blog/1999/12/testing' do
    it 'loads the blog post, including its comments' do
      get "/blog/#{@post.posted_year}/#{@post.posted_month}/#{@post.slug}"

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title @post.title
      expect( response.body ).to have_css 'h3', text: I18n.t( 'comments.title' )
    end
  end
end
