require 'rails_helper'

RSpec.describe PageSection, type: :model do
  context '.default_page' do
    it 'returns the correct page' do
      section = create :page_section
      create :top_level_page
      page1 = create :page, section: section
      page2 = create :page, section: section
      expect( page2.section.default_page ).to eq page1
    end
  end
end
