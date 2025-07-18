# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for shop section model
RSpec.describe ShinyShop::Section, type: :model do
  describe 'when I call .default_page' do
    it 'with no default set, it returns the first page created in this section' do
      section = create :shop_section

      product1 = create :product, section: section
      product2 = create :product, section: section

      expect( product2.section.default_page ).to eq product1
    end

    it 'returns the specified page if a default has been explicitly set' do
      section = create :shop_section

      product1 = create :product, section: section
      product2 = create :product, section: section

      section.update! default_product_id: product2.id

      expect( product1.section.default_product ).to eq product2
    end
  end

  describe 'when I call Section.default_section' do
    it 'returns the correct section' do
      create :shop_section
      section2 = create :shop_section, slug: 'default'

      ShinyCMS::Setting.set( :default_section, to: 'default' )

      expect( described_class.default_section ).to eq section2
    end
  end

  describe 'check that position is applied within a section' do
    it 'returns the sections ordered by position, nulls last (not by .id or .created_at)' do
      s0 = create :shop_section
      s1 = create :shop_section, section: s0, position: 6
      s2 = create :shop_section, section: s0
      s3 = create :shop_section, section: s0, position: 2
      s4 = create :shop_section, section: s0, position: 5
      s5 = create :shop_section, section: s1, position: 6

      expect( s0.sections.first  ).to eq s3
      expect( s0.sections.second ).to eq s4
      expect( s0.sections.third  ).to eq s1
      expect( s0.sections.last   ).to eq s2
      expect( s0.sections.size   ).to eq 4
      # expect( s0.sections      ).not_to include s5
      expect( s1.sections.first  ).to eq s5
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end
  end
end
