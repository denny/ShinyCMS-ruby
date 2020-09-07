# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

module ShinyNewsletters
  RSpec.describe Template, type: :model do
    context 'class methods' do
      describe '.file_exists?' do
        it 'returns true if the template file exists on the disk' do
          template = create :page_template, filename: 'an_example'
          expect( template.file_exists? ).to eq true
        end

        it 'it returns false if the template file does not exist' do
          template = build :page_template, filename: 'NO-SUCH-FILE'
          expect( template.file_exists? ).to eq false
        end
      end

      describe '.elements' do
        it 'returns the template elements' do
          template = create :page_template

          expect( template.elements.size ).to eq 4
        end
      end

      describe '.available_templates' do
        it 'returns the names of the template files in newsletters/templates' do
          expect( described_class.available_templates.size  ).to eq 1
          expect( described_class.available_templates.first ).to eq 'an_example'
        end
      end
    end

    context 'concerns' do
      it_should_behave_like ShinyDemoDataProvider do
        let( :model ) { described_class }
      end
    end
  end
end
