# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Page model:', type: :model do
  context 'when I call Page.default_page' do
    it 'without a setting, it returns the first page created' do
      page1 = create :page, slug: 'first'
      create :page, slug: 'default'

      expect( Page.default_page ).to eq page1
    end

    it 'with a setting, it returns the specified page, not the first page' do
      create :page, slug: 'first'
      page2 = create :page, slug: 'default'

      Setting.set( :default_page ).to 'default'

      expect( Page.default_page ).to eq page2
    end
  end
end
