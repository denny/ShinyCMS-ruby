# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for product template model
RSpec.describe ShinyShop::Template, type: :model do
  describe 'instance methods' do
    describe '.products' do
      it 'returns the associated products' do
        template = create :product_template
        create :product, template: template
        create :product, template: template
        expect( template.products.size ).to eq 2
      end
    end

    describe '.file_exists?' do
      it 'returns true if the template file exists on the disk' do
        template = create :product_template, filename: 'an_example'
        expect( template.file_exists? ).to be true
      end

      it 'returns false if the template file does not exist' do
        template = build :product_template, filename: 'NO-SUCH-FILE'
        expect( template.file_exists? ).to be false
      end
    end

    describe '.elements' do
      it 'returns the template elements' do
        template = create :product_template

        expect( template.elements.size ).to eq 4
      end
    end
  end

  describe 'class methods' do
    describe '.available_templates' do
      it 'returns the names of the template files in products/templates' do
        expect( described_class.available_templates.size  ).to eq 1
        expect( described_class.available_templates.first ).to eq 'an_example'
      end
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end
  end
end
