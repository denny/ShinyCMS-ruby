# frozen_string_literal: true

require 'rails_helper'

module ShinyNews
  RSpec.describe Post, type: :model do
    context 'factory' do
      it 'can create a news post' do
        post = create :news_post
        expect( ShinyNews::Post.first ).to eq post
      end
    end

    context 'concerns' do
      it_should_behave_like ShinyDemoDataProvider do
        let( :model ) { described_class }
      end

      it_should_behave_like ShinyPost do
        let( :post ) { create :news_post }
      end

      it_should_behave_like 'Voteable' do
        let( :item ) { create :news_post }
      end
    end
  end
end
