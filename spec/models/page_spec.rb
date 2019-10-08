require 'rails_helper'

RSpec.describe Page, type: :model do
  context 'Page.default_page' do
    it 'returns the correct page' do
      create :page, slug: 'first'
      page2 = create :page, slug: 'default'

      Setting.create! name: 'Default page', value: 'default'

      expect( Page.default_page ).to eq page2
    end
  end

  context 'Page.are_there_any_hidden_pages?' do
    it 'correctly says yep' do
      create :page, :hidden
      expect( Page.are_there_any_hidden_pages? ).to eq true
    end
    it 'correctly says nope' do
      create :page
      expect( Page.are_there_any_hidden_pages? ).to eq false
    end
  end
end
