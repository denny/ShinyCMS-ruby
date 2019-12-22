require 'rails_helper'

RSpec.describe Blog, type: :model do
  context 'factory' do
    it 'can create a blog' do
      blog = create :blog

      expect( Blog.first ).to eq blog
    end

    it 'can fetch the hidden posts' do
      blog = create :blog
      create :blog_post, blog: blog, hidden: true
      create :blog_post, blog: blog
      create :blog_post, blog: blog, hidden: true

      expect( blog.hidden_posts.length ).to eq 2
    end

    it 'can fetch the non-hidden posts' do
      blog = create :blog
      create :blog_post, blog: blog, hidden: true
      create :blog_post, blog: blog
      create :blog_post, blog: blog, hidden: true

      expect( blog.posts.length ).to eq 1
    end

    it 'can fetch all of the posts' do
      blog = create :blog
      create :blog_post, blog: blog, hidden: true
      create :blog_post, blog: blog
      create :blog_post, blog: blog, hidden: true

      expect( blog.all_posts.length ).to eq 3
    end
  end
end
