# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared test code for behaviour mixed-in by the ShinyCMS::Post concern
RSpec.shared_examples ShinyCMS::Post do
  describe 'methods' do
    describe '.generate_slug' do
      it 'can create a slug' do
        post.slug = nil
        expect( post.slug ).to be_blank

        post.generate_slug
        expect( post.slug ).to eq post.title.parameterize
      end
    end

    describe '.teaser' do
      it 'returns a teaser with the default number of paragraphs (3)' do
        paras = Faker::Lorem.paragraphs( number: 5 )
        text  = paras.join( "\n</p>\n<p>" )
        body  = "<p>#{text}\n</p>"
        post.update!( body: body )

        expect( post.teaser ).to     match %r{<p>.+<p>.+<p>}m
        expect( post.teaser ).not_to match %r{<p>.+<p>.+<p>.+<p>}m
      end
    end

    describe '.teaser( paragraphs: 4 )' do
      it 'returns a teaser with the specified number of paragraphs' do
        paras = Faker::Lorem.paragraphs( number: 5 )
        text  = paras.join( "\n</p>\n<p>" )
        body  = "<p>#{text}\n</p>"
        post.update!( body: body )

        expect( post.teaser( paragraphs: 4 ) ).to     match %r{<p>.+<p>.+<p>.+<p>}m
        expect( post.teaser( paragraphs: 4 ) ).not_to match %r{<p>.+<p>.+<p>.+<p>.+<p>}m
      end
    end
  end

  describe 'scopes' do
    let( :older ) do
      post.class.create!(
        title:     Faker::Books::CultureSeries.unique.culture_ship,
        body:      'Yesterday',
        user:      post.author,
        posted_at: 1.day.ago
      )
    end

    let( :hidden ) do
      post.class.create!(
        title:        Faker::Books::CultureSeries.unique.culture_ship,
        body:         'Today',
        user:         post.author,
        posted_at:    1.minute.ago,
        show_on_site: false
      )
    end

    let( :future ) do
      post.class.create!(
        title:     Faker::Books::CultureSeries.unique.culture_ship,
        body:      'Tomorrow',
        user:      post.author,
        posted_at: 1.day.since
      )
    end

    before do
      post.update!( posted_at: 1.hour.ago )
      older
      hidden
      future
    end

    describe '.visible' do
      it "returns posts that aren't hidden" do
        expect( post.class.visible.size ).to eq 3
        expect( post.class.visible.last ).to eq future
      end
    end

    describe '.not_future_dated' do
      it "returns posts that aren't future-dated" do
        expect( post.class.not_future_dated.size ).to eq 3
        expect( post.class.not_future_dated.last ).to eq hidden
      end
    end

    describe '.published' do
      it "returns posts that aren't hidden or future-dated" do
        expect( post.class.published.size ).to eq 2
        expect( post.class.published.last ).to eq post
      end
    end

    describe '.recent' do
      it "returns posts that aren't hidden or future-dated, in most-recent-first order" do
        expect( post.class.recent.size ).to eq 2
        expect( post.class.recent.last ).to eq older
      end
    end
  end
end
