# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blog, type: :model do
  context 'factory' do
    it 'can create a blog' do
      blog = create :blog

      expect( Blog.first ).to eq blog
    end
  end

  context 'scopes' do
    it 'can fetch the visible posts (not hidden, not future-dated)' do
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

  context 'scopes' do
    it 'can create a title' do
      blog = create :blog

      blog.title = nil
      expect( blog.title ).to be_blank

      blog.generate_title
      expect( blog.title ).to match %r{[-\w]+}
    end

    it 'can create a slug' do
      blog = create :blog

      blog.slug = nil
      expect( blog.slug ).to be_blank

      blog.generate_slug
      expect( blog.slug ).to match %r{[-\w]+}
    end
  end
end
