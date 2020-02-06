require 'rails_helper'

RSpec.describe PageSection, type: :model do
  context '.default_page' do
    it 'returns the first page in the section if no default is set' do
      create :top_level_page
      section = create :page_section
      page001 = create :page, section: section
      page002 = create :page, section: section
      expect( page002.section.default_page ).to eq page001
    end

    it 'returns the correct default page if one is set' do
      create :top_level_page
      section = create :page_section
      page001 = create :page, section: section
      page002 = create :page, section: section
      section.update! default_page_id: page002.id
      expect( page001.section.default_page ).to eq page002
    end
  end

  context 'PageSection.default_section' do
    it 'returns the correct section' do
      create :page_section
      section2 = create :page_section, slug: 'default'

      setting = create :setting, name: 'default_section'
      create :setting_value, setting_id: setting.id, value: 'default'

      expect( PageSection.default_section ).to eq section2
    end
  end
end
