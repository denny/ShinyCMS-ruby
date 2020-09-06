# frozen_string_literal: true

require 'rails_helper'

module ShinyPages
  RSpec.describe Page, type: :model do
    describe 'when I call ShinyPages::Page.default_page' do
      it 'without a setting, it returns the first page created' do
        page1 = create :page, slug: 'first'
        create :page, slug: 'default'

        expect( ShinyPages::Page.default_page ).to eq page1
      end

      it 'with a setting, it returns the specified page, not the first page' do
        create :page, slug: 'first'
        page2 = create :page, slug: 'default'

        Setting.set( :default_page, to: 'default' )

        expect( ShinyPages::Page.default_page ).to eq page2
      end
    end

    describe 'check that sort_order is applied' do
      it 'returns the pages ordered by sort_order, nulls last (not by .id or .created_at)' do
        p1 = create :page, sort_order: 6
        p2 = create :page
        p3 = create :page, sort_order: 2
        p4 = create :page, sort_order: 5

        expect( ShinyPages::Page.first  ).to eq p3
        expect( ShinyPages::Page.second ).to eq p4
        expect( ShinyPages::Page.third  ).to eq p1
        expect( ShinyPages::Page.last   ).to eq p2
      end
    end

    context 'concerns' do
      it_should_behave_like ShinyDemoDataProvider do
        let( :model ) { described_class }
      end
    end
  end
end
