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
end
