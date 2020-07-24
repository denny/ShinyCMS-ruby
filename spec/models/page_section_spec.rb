# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PageSection model:', type: :model do
  describe 'when I call .default_page' do
    it 'with no default set, it returns the first page created in this section' do
      section = create :page_section

      page1 = create :page, section: section
      page2 = create :page, section: section

      expect( page2.section.default_page ).to eq page1
    end

    it 'it returns the specified page if a default has been explicitly set' do
      section = create :page_section

      page1 = create :page, section: section
      page2 = create :page, section: section

      section.update! default_page_id: page2.id

      expect( page1.section.default_page ).to eq page2
    end
  end

  describe 'when I call PageSection.default_section' do
    it 'it returns the correct section' do
      create :page_section
      section2 = create :page_section, slug: 'default'

      Setting.set( :default_section, to: 'default' )

      expect( PageSection.default_section ).to eq section2
    end
  end

  describe 'check that sort_order is applied' do
    it 'returns the sections ordered by sort_order, nulls last (not by .id or .created_at)' do
      s1 = create :page_section, sort_order: 6
      s2 = create :page_section
      s3 = create :page_section, sort_order: 2
      s4 = create :page_section, sort_order: 5

      expect( PageSection.first  ).to eq s3
      expect( PageSection.second ).to eq s4
      expect( PageSection.third  ).to eq s1
      expect( PageSection.last   ).to eq s2
    end
  end
end
