# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Tests for news post model
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
