# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared tests for methods and behaviour mixed-in by the ShinyPaginationHelper
RSpec.shared_examples 'Pagination' do |factory, base_url, match_tag, match_text|
  let( :items ) { create_list factory.to_sym, 12, posted_at: 1.day.ago }

  before :each do
    @items = items
    # TODO: FIXME: there has _got_ to be a better way to do this, in the create_list call I assume
    # Attempt to fix flappy tests by setting different posted_at timestamps to order them by
    @items.each do |item|
      item.update!( posted_at: item.posted_at + item.id.minutes )
    end
    @items = @items.reverse # recent posts page is from newest to oldest
  end

  context 'when viewing a list with twelve items in it' do
    describe 'loading the page with no pagination params in the URL' do
      it 'shows the first ten items' do
        get base_url

        expect( response.body ).to have_css match_tag, text: @items[0].public_send( match_text )
        expect( response.body ).to have_css match_tag, text: @items[9].public_send( match_text )

        expect( response.body ).not_to have_css match_tag, text: @items[10].public_send( match_text )
      end
    end

    describe 'specifying the first page, but not specifying a count' do
      it 'shows the first ten items' do
        get "#{base_url}?page=1"
        params = { page: 1 }

        get "#{base_url}?#{params.to_query}"

        expect( response.body ).to have_css match_tag, text: @items[0].public_send( match_text )
        expect( response.body ).to have_css match_tag, text: @items[9].public_send( match_text )

        expect( response.body ).not_to have_css match_tag, text: @items[10].public_send( match_text )
      end
    end

    describe 'specifying the first page, and a count of 5 items' do
      it 'shows the first 5 items' do
        params = { page: 1, count: 5 }

        get "#{base_url}?#{params.to_query}"

        expect( response.body ).to have_css match_tag, text: @items[0].public_send( match_text )
        expect( response.body ).to have_css match_tag, text: @items[4].public_send( match_text )

        expect( response.body ).not_to have_css match_tag, text: @items[5].public_send( match_text )
      end
    end

    describe 'specifying a count of 5 items, but not specifying a page' do
      it 'shows the first 5 items' do
        get "#{base_url}?count=5"
        params = { count: 5 }

        get "#{base_url}?#{params.to_query}"

        expect( response.body ).to have_css match_tag, text: @items[0].public_send( match_text )
        expect( response.body ).to have_css match_tag, text: @items[4].public_send( match_text )

        expect( response.body ).not_to have_css match_tag, text: @items[5].public_send( match_text )
      end
    end

    describe 'requesting the second page with default count' do
      it 'shows the last two items' do
        get "#{base_url}?page=2"
        params = { page: 2 }

        get "#{base_url}?#{params.to_query}"

        expect( response.body ).not_to have_css match_tag, text: @items[1].public_send( match_text )

        expect( response.body ).to have_css match_tag, text: @items[10].public_send( match_text )
        expect( response.body ).to have_css match_tag, text: @items[11].public_send( match_text )
      end
    end

    describe 'specifying the second page, and a count of 5 items' do
      it 'shows items 6 to 10' do
        params = { page: 2, count: 5 }

        get "#{base_url}?#{params.to_query}"

        expect( response.body ).not_to have_css match_tag, text: @items[4].public_send( match_text )

        expect( response.body ).to have_css match_tag, text: @items[5].public_send( match_text )
        expect( response.body ).to have_css match_tag, text: @items[9].public_send( match_text )

        expect( response.body ).not_to have_css match_tag, text: @items[10].public_send( match_text )
      end
    end
  end
end
