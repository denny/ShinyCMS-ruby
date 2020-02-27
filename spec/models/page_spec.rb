require 'rails_helper'

RSpec.describe Page, type: :model do
  context 'Page.default_page' do
    it 'returns the correct page' do
      create :page, slug: 'first'
      page2 = create :page, slug: 'default'

      setting = create :setting, name: 'default_page'
      create :setting_value, setting_id: setting.id, value: 'default'

      expect( Page.default_page ).to eq page2
    end
  end
end
