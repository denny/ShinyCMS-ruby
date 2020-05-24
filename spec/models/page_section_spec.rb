# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PageSection model:', type: :model do
  context 'when I call .default_page' do
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

  context 'when I call PageSection.default_section' do
    it 'it returns the correct section' do
      create :page_section
      section2 = create :page_section, slug: 'default'

      Setting.set( :default_section, to: 'default' )

      expect( PageSection.default_section ).to eq section2
    end
  end
end
