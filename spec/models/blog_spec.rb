require 'rails_helper'

RSpec.describe Blog, type: :model do
  context 'factory' do
    it 'can create a blog' do
      blog = create :blog
      expect( Blog.first ).to eq blog
    end
  end
end
