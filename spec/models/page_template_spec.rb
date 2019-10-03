require 'rails_helper'

RSpec.describe PageTemplate, type: :model do
  context '.pages' do
    it 'returns the associated pages' do
      template = create :page_template
      create :page, template: template
      create :page, template: template
      expect( template.pages.size ).to eq 2
    end
  end
end
