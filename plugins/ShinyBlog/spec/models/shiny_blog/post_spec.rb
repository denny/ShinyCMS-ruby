# frozen_string_literal: true

require 'rails_helper'

module ShinyBlog
  RSpec.describe Post, type: :model do
    context 'factory' do
      it 'can create a blog post' do
        post = create :blog_post
        expect( ShinyBlog::Post.first ).to eq post
      end
    end

    it_should_behave_like ShinyDemoDataProvider do
      let( :model ) { described_class }
    end

    it_should_behave_like ShinyPost do
      let( :post ) { create :blog_post }
    end

    it_should_behave_like 'Voteable' do
      let( :item ) { create :blog_post }
    end
  end
end
