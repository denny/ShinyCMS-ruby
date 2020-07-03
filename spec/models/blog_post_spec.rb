# frozen_string_literal: true

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

    it 'can create a teaser with default number of paragraphs' do
      paras = Faker::Lorem.paragraphs( number: 5 )
      text  = paras.join( "\n</p>\n<p>" )
      body  = "<p>#{text}\n</p>"
      post  = create :blog_post, body: body

      expect( post.teaser ).to     match %r{<p>.+<p>.+<p>}m
      expect( post.teaser ).not_to match %r{<p>.+<p>.+<p>.+<p>}m
    end

    it 'can create a teaser with specified number of paragraphs' do
      paras = Faker::Lorem.paragraphs( number: 5 )
      text  = paras.join( "\n</p>\n<p>" )
      body  = "<p>#{text}\n</p>"
      post  = create :blog_post, body: body

      expect( post.teaser( paragraphs: 4 ) ).to     match %r{<p>.+<p>.+<p>.+<p>}m
      expect( post.teaser( paragraphs: 4 ) ).not_to match %r{<p>.+<p>.+<p>.+<p>.+<p>}m
    end
  end

  it_should_behave_like 'Voteable' do
    let( :item ) { create :blog_post }
  end
end
