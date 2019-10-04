require 'rails_helper'

RSpec.describe PageSection, type: :model do
  context '.default_page' do
    it 'returns the correct page' do
      create :top_level_page
      section = create :page_section
      page001 = create :page, section: section
      page002 = create :page, section: section
      expect( page002.section.default_page ).to eq page001
    end
  end

  context 'PageSection.default_section' do
    it 'returns the correct section' do
      create :page_section
      section2 = create :page_section, name: 'Test2'

      SiteSetting.create( name: 'default_section', value: 'Test2' )

      expect( PageSection.default_section ).to eq section2
    end
  end
end
