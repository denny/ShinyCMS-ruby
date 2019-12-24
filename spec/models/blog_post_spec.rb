require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  context 'factory' do
    it 'can create a blog post' do
      post = create :blog_post
      expect( BlogPost.first ).to eq post
    end
  end

  context 'methods' do
    it 'can create a slug' do
      post = create :blog_post

      post.slug = nil
      expect( post.slug ).to be_blank

      post.generate_slug
      expect( post.slug ).to match %r{[-\w]+}
    end
  end
end
