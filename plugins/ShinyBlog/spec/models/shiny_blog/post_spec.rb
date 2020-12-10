# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for blog post model
module ShinyBlog
  RSpec.describe Post, type: :model do
    context 'factory' do
      it 'can create a blog post' do
        post = create :blog_post
        expect( described_class.first ).to eq post
      end
    end

    context 'concerns' do
      it_behaves_like ShinyDemoDataProvider do
        let( :model ) { described_class }
      end

      it_behaves_like ShinyPost do
        let( :post ) { create :blog_post }
      end

      it_behaves_like 'Voteable' do
        let( :item ) { create :blog_post }
      end
    end
  end
end
