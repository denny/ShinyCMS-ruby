require 'rails_helper'
require 'fileutils'

RSpec.describe PageTemplate, type: :model do
  # orig_dir = Rails.root.join( 'app', 'views', 'pages', 'templates' )
  # temp_dir = Rails.root.join( 'app', 'views', 'pages', 'temp' )
  # test_dir = Rails.root.join( 'spec', 'fixtures', 'templates' )

  # before :all do
  #   FileUtils.mv orig_dir, temp_dir
  #   FileUtils.mv test_dir, orig_dir
  # end

  # after :all do
  #   FileUtils.mv orig_dir, test_dir
  #   FileUtils.mv temp_dir, orig_dir
  # end

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
      template = create :page_template, filename: 'an_example'
      expect( template.file_exists? ).to eq true
    end

    it 'returns false if the template file does not exist' do
      template = build :page_template, filename: 'NO-SUCH-FILE'
      expect( template.file_exists? ).to eq false
    end
  end

  context 'PageTemplate.available_templates' do
    it 'returns the names of the template files in pages/templates' do
      expect( PageTemplate.available_templates.size  ).to eq 6
      expect( PageTemplate.available_templates.first ).to eq 'an_example'
    end
  end

  context '.elements' do
    it 'returns the template elements' do
      template = create :page_template

      expect( template.elements.size ).to eq 4
    end
  end
end
