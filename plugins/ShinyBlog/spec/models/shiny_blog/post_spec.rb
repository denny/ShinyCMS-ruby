# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for blog post model
RSpec.describe ShinyBlog::Post, type: :model do
  describe 'factory' do
    it 'can create a blog post' do
      post1 = create :blog_post

      expect( described_class.first ).to eq post1
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end

    it_behaves_like ShinyCMS::Post do
      let( :post ) { create :blog_post }
    end

    it_behaves_like 'Voteable' do
      let( :item ) { create :blog_post }
    end

    describe 'tag interactions with hidden content' do
      it 'hides the tags when the post is hidden' do
        post1 = create :blog_post, tag_list: 'shiny, cms, tests'

        expect( post1.hidden_tag_list.size ).to eq 0
        expect( post1.tag_list.size        ).to eq 3

        post1.hide

        expect( post1.hidden_tag_list.size ).to eq 3
        expect( post1.tag_list.size        ).to eq 0
      end

      it 'shows the tags when the post is unhidden' do
        post1 = create :blog_post, tag_list: 'shiny, cms, tests', show_on_site: false

        expect( post1.hidden_tag_list.size ).to eq 3
        expect( post1.tag_list.size        ).to eq 0

        post1.show

        expect( post1.hidden_tag_list.size ).to eq 0
        expect( post1.tag_list.size        ).to eq 3
      end
    end
  end
end
