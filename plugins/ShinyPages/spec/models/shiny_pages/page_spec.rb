# frozen_string_literal: true

require 'rails_helper'

module ShinyPages
  RSpec.describe Page, type: :model do
    describe 'when I call Page.default_page' do
      it 'without a setting, it returns the first page created' do
        page1 = create :page, slug: 'first'
        create :page, slug: 'default'

        expect( Page.default_page ).to eq page1
      end

      it 'with a setting, it returns the specified page, not the first page' do
        create :page, slug: 'first'
        page2 = create :page, slug: 'default'

        ::Setting.set( :default_page, to: 'default' )

        expect( Page.default_page ).to eq page2
      end
    end

    describe 'check that pages are sorted by position (not by .id or .created_at)' do
      context 'at top level' do
        it 'returns the pages ordered by position, nulls/defaults last' do
          s0 = create :page_section

          p1 = create :top_level_page, position: 6
          p2 = create :top_level_page
          p3 = create :page, section: s0
          p4 = create :top_level_page, position: 2
          p5 = create :top_level_page, position: 5

          expect( Page.top_level.first  ).to eq p4
          expect( Page.top_level.second ).to eq p5
          expect( Page.top_level.third  ).to eq p1
          expect( Page.top_level.last   ).to eq p2

          expect( Page.top_level.size   ).to eq 4
          expect( s0.all_pages.first                      ).to eq p3
          # expect( Page.top_level      ).not_to include p3
        end
      end

      context 'within a section' do
        it 'returns the pages in that section ordered by assigned position, nulls/defaults last' do
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
    end

    context 'concerns' do
      it_should_behave_like ShinyDemoDataProvider do
        let( :model ) { described_class }
      end
    end
  end
end
