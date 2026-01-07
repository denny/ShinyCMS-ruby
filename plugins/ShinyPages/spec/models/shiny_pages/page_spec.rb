# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for page model
RSpec.describe ShinyPages::Page, type: :model do
  describe 'class .default_page' do
    context 'without a setting' do
      it 'returns the first page created' do
        page1 = create :page, slug: 'first'
        create :page, slug: 'default'

        expect( described_class.default_page ).to eq page1
      end
    end

    context 'with a setting' do
      it 'returns the specified page, not the first page' do
        create :page, slug: 'first'
        page2 = create :page, slug: 'default'

        ShinyCMS::Setting.set( :default_page, to: 'default' )

        expect( described_class.default_page ).to eq page2
      end
    end
  end

  describe 'instance methods' do
    describe '.path' do
      it 'provides the correct path for a top level page' do
        p1 = create :top_level_page

        expect( p1.path ).to eq "/#{p1.slug}"
      end

      it 'provides the correct path for a page in a sub-section' do
        p1 = create :page_in_nested_section

        expect( p1.path ).to eq "/#{p1.section.section.slug}/#{p1.section.slug}/#{p1.slug}"
      end
    end
  end

  describe 'sort order' do
    it 'orders the top level pages by specified position, nulls/defaults last' do
      s0 = create :page_section

      p1 = create :top_level_page, position: 6
      p2 = create :top_level_page
      p3 = create :page, section: s0
      p4 = create :top_level_page, position: 2
      p5 = create :top_level_page, position: 5

      expect( described_class.top_level.first  ).to eq p4
      expect( described_class.top_level.second ).to eq p5
      expect( described_class.top_level.third  ).to eq p1
      expect( described_class.top_level.last   ).to eq p2

      expect( described_class.top_level.size   ).to eq 4
      expect( s0.all_pages.first               ).to eq p3
      expect( described_class.top_level        ).not_to include p3
    end

    it 'orders the pages in a section by specified position, nulls/defaults last' do
      s0 = create :page_section
      s1 = create :page_section

      p1 = create :page, section: s0, position: 6
      p2 = create :page, section: s0
      p3 = create :page, section: s1
      p4 = create :page, section: s0, position: 2
      p5 = create :page, section: s0, position: 5

      expect( s0.all_pages.first  ).to eq p4
      expect( s0.all_pages.second ).to eq p5
      expect( s0.all_pages.third  ).to eq p1
      expect( s0.all_pages.last   ).to eq p2

      expect( s0.all_pages.size   ).to eq 4
      expect( s1.all_pages.first  ).to eq p3
      # expect( s0.pages          ).not_to include p3
    end
  end

  describe 'validations' do
    it 'fails with appropriate error when top-level slug collides with existing route' do
      colliding = build :page, slug: 'admin'

      expect( colliding.valid? ).to be false
      expect( colliding.errors.full_messages_for( :slug ) ).to contain_exactly 'Slug cannot be used as a top-level slug'
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end
  end
end
