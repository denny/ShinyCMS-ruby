require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  context 'factory' do
    it 'can create a blog post' do
      post = create :blog_post
      expect( BlogPost.first ).to eq post
    end
  end
end
