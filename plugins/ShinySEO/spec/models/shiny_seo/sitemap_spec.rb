# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for sitemap model
module ShinySEO
  RSpec.describe Sitemap, type: :model do
    describe '.generate' do
      it 'generates a sitemap' do
        create :top_level_page
        create :page_in_nested_section, created_at: 1.year.ago, updated_at: 3.months.ago
        create :blog_post
        p1 = create :news_post
        d1 = create :discussion, resource: p1
        create :comment, discussion: d1

        SitemapGenerator::Sitemap.verbose = false

        result = described_class.new.generate

        expect( result ).to be_a SitemapGenerator::LinkSet
        expect( result.link_count ).to eq 6 # two pages, two posts, two post author profiles
      end
    end
  end
end
