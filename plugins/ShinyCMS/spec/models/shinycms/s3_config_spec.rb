# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyCMS::S3Config model
RSpec.describe ShinyCMS::S3Config, type: :model do
  let( :bucket ) { 'shinycms-tests' }
  let( :region ) { 'eu-test-1'      }

  before do
    allow( ENV ).to receive( :fetch ).with( 'AWS_S3_FEEDS_SECRET_ACCESS_KEY', nil ).and_return 'test'

    allow( ENV ).to receive( :fetch ).with( 'AWS_S3_FEEDS_BUCKET', nil ).and_return bucket
    allow( ENV ).to receive( :fetch ).with( 'AWS_S3_FEEDS_REGION', nil ).and_return region
  end

  context 'when all S3 config details are present in ENV' do
    before do
      allow( ENV ).to receive( :fetch ).with( 'AWS_S3_FEEDS_ACCESS_KEY_ID', nil ).and_return 'test'
    end

    describe '.region' do
      it 'returns the value of the corresponding ENV var' do
        s3_config = described_class.get( :feeds )

        expect( s3_config.region ).to eq region
      end
    end

    describe '.base_url' do
      it 'generates an S3 base URL' do
        s3_config = described_class.get( :feeds )

        allow( ENV ).to receive( :fetch ).with( 'SHINYCMS_USE_HTTPS', nil ).and_return 'true'

        expect( s3_config.base_url ).to eq "https://#{bucket}.s3.#{region}.amazonaws.com"
      end
    end

    describe '.custom_url' do
      it 'returns the configured custom URL' do
        s3_config = described_class.get( :feeds )

        allow( ENV ).to receive( :fetch ).with( 'AWS_S3_FEEDS_CUSTOM_URL', nil ).and_return 'https://example.net/'
        # Note that if you configure a custom URL, the HTTPS setting is irrelevant
        allow( ENV ).to receive( :fetch ).with( 'SHINYCMS_USE_HTTPS', 'false' ).and_return 'false'

        expect( s3_config.custom_url ).to eq 'https://example.net'
      end
    end
  end

  context 'when any item of S3 config is missing from ENV' do
    before do
      allow( ENV ).to receive( :fetch ).with( 'AWS_S3_FEEDS_ACCESS_KEY_ID', nil ).and_return nil
    end

    describe '.get( label )' do
      it 'returns nil' do
        s3_config = described_class.get( :feeds )

        expect( s3_config ).to be_nil
      end
    end
  end
end
