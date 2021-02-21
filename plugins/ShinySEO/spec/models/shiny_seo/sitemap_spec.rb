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
    describe 'new' do
      context 'when S3 config is present' do
        let( :bucket ) { 'shinycms-tests' }
        let( :region ) { 'eu-test-1'      }

        before do
          @original_adapter = SitemapGenerator::Sitemap.adapter

          allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_BASE_URL' ).and_return nil
          allow( ENV ).to receive( :[] ).with( 'SHINYCMS_USE_HTTPS'    ).and_return nil

          allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_SECRET_ACCESS_KEY' ).and_return 'test'
          allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_ACCESS_KEY_ID'     ).and_return 'test'

          allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_BUCKET' ).and_return bucket
          allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_REGION' ).and_return region
        end

        after do
          SitemapGenerator::Sitemap.adapter = @original_adapter
        end

        it 'uses the S3 adapter' do
          described_class.new

          expect( SitemapGenerator::Sitemap.adapter ).to be_a SitemapGenerator::AwsSdkAdapter
        end
      end
    end

    describe '.generate' do
      before do
        create :top_level_page
        create :page_in_nested_section, created_at: 1.year.ago, updated_at: 3.months.ago
        create :blog_post
        p1 = create :news_post
        d1 = create :discussion, resource: p1
        create :comment, discussion: d1
      end

      it 'generates a sitemap' do
        SitemapGenerator::Sitemap.verbose = false

        result = described_class.new.generate

        expect( result ).to be_a SitemapGenerator::LinkSet
        expect( result.link_count ).to eq 6 # two pages, two posts, two post author profiles
      end
    end
  end
end
