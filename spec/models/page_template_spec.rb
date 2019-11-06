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
      template = build :page_template, filename: 'NO-SUCH-FILE'
      expect( template.file_exists? ).to eq false
    end
  end

  context 'PageTemplate.available_templates' do
    it 'returns the names of the template files in pages/templates' do
      expect( PageTemplate.available_templates.size  ).to eq 1
      expect( PageTemplate.available_templates.first ).to eq 'example'
    end
  end

  context '.elements' do
    it 'returns the template elements' do
      template = create :page_template

      expect( template.elements.size ).to eq 3
    end
  end
end
