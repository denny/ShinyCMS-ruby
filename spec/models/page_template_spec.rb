# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PageTemplate model:', type: :model do
  context ' when I call .pages' do
    it 'it returns the associated pages' do
      template = create :page_template
      create :page, template: template
      create :page, template: template
      expect( template.pages.size ).to eq 2
    end
  end

  context 'when I call .file_exists?' do
    it 'it returns true if the template file exists on the disk' do
      template = create :page_template, filename: 'an_example'
      expect( template.file_exists? ).to eq true
    end

    it 'it returns false if the template file does not exist' do
      template = build :page_template, filename: 'NO-SUCH-FILE'
      expect( template.file_exists? ).to eq false
    end
  end

  context 'when I call .elements' do
    it 'it returns the template elements' do
      template = create :page_template

      expect( template.elements.size ).to eq 4
    end
  end

  context 'when I call PageTemplate.available_templates' do
    it 'it returns the names of the template files in pages/templates' do
      expect( PageTemplate.available_templates.size  ).to eq 1
      expect( PageTemplate.available_templates.first ).to eq 'an_example'
    end
  end
end
