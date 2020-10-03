# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for blog post model - ShinyBlogs plugin for ShinyCMS
module ShinyBlogs
  RSpec.describe BlogPost, type: :model do
    context 'factory' do
      it 'can create a blog post' do
        post = create :shiny_blogs_blog_post
        expect( ShinyBlogs::BlogPost.first ).to eq post
      end
    end

    context 'methods' do
      it 'can create a slug' do
        post = create :shiny_blogs_blog_post

        post.slug = nil
        expect( post.slug ).to be_blank

        post.generate_slug
        expect( post.slug ).to match %r{[-\w]+}
      end

      it 'can create a teaser with default number of paragraphs' do
        paras = Faker::Lorem.paragraphs( number: 5 )
        text  = paras.join( "\n</p>\n<p>" )
        body  = "<p>#{text}\n</p>"
        post  = create :shiny_blogs_blog_post, body: body

        expect( post.teaser ).to     match %r{<p>.+<p>.+<p>}m
        expect( post.teaser ).not_to match %r{<p>.+<p>.+<p>.+<p>}m
      end

      it 'can create a teaser with specified number of paragraphs' do
        paras = Faker::Lorem.paragraphs( number: 5 )
        text  = paras.join( "\n</p>\n<p>" )
        body  = "<p>#{text}\n</p>"
        post  = create :shiny_blogs_blog_post, body: body

        expect( post.teaser( paragraphs: 4 ) ).to     match %r{<p>.+<p>.+<p>.+<p>}m
        expect( post.teaser( paragraphs: 4 ) ).not_to match %r{<p>.+<p>.+<p>.+<p>.+<p>}m
      end
    end

    it_should_behave_like 'Voteable' do
      let( :item ) { create :shiny_blogs_blog_post }
    end

    it_should_behave_like ShinyDemoDataProvider do
      let( :model ) { described_class }
    end
  end
end
