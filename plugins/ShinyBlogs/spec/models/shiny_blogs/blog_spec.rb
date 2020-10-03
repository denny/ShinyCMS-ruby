# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for blog model - ShinyBlogs plugin for ShinyCMS
module ShinyBlogs
  RSpec.describe Blog, type: :model do
    context 'factory' do
      it 'can create a blog' do
        blog = create :shiny_blogs_blog

        expect( ShinyBlogs::Blog.first ).to eq blog
      end
    end

    context 'scopes' do
      it 'can fetch the visible posts (not hidden, not future-dated)' do
        blog = create :shiny_blogs_blog
        create :shiny_blogs_blog_post, blog: blog, show_on_site: false
        create :shiny_blogs_blog_post, blog: blog
        create :shiny_blogs_blog_post, blog: blog, show_on_site: false

        expect( blog.posts.length ).to eq 1
      end

      it 'can fetch all of the posts' do
        blog = create :shiny_blogs_blog
        create :shiny_blogs_blog_post, blog: blog, show_on_site: false
        create :shiny_blogs_blog_post, blog: blog
        create :shiny_blogs_blog_post, blog: blog, show_on_site: false

        expect( blog.all_posts.length ).to eq 3
      end
    end

    context 'methods' do
      describe '.name' do
        it 'returns the public_name if one is set' do
          blog = create :shiny_blogs_blog, public_name: Faker::Books::CultureSeries.unique.culture_ship

          expect( blog.name ).not_to eq blog.internal_name
          expect( blog.name ).to eq blog.public_name
        end

        it 'returns the internal_name if public_name is not set' do
          blog = create :shiny_blogs_blog, public_name: nil

          expect( blog.public_name ).to be_blank

          expect( blog.name ).to eq blog.internal_name
        end
      end

      describe '.generate_slug' do
        it 'can create a slug' do
          blog = create :shiny_blogs_blog

          blog.slug = nil
          expect( blog.slug ).to be_blank

          blog.generate_slug
          expect( blog.slug ).to match %r{[-\w]+}
        end
      end
    end

    it_should_behave_like ShinyDemoDataProvider do
      let( :model ) { described_class }
    end
  end
end
