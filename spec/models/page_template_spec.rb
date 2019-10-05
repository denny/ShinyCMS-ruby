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
  context '.file_exists?' do
    it 'returns true if the template file exists on the disk' do
      template = create :page_template, filename: 'example'
      expect( template.file_exists? ).to eq true
    end
    it 'returns false if the template file does not exist' do
      template = create :page_template, filename: 'NO-SUCH-FILE'
      expect( template.file_exists? ).to eq false
    end
  end
end
