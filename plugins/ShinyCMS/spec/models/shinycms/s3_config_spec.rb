# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyCMS::S3Config model
RSpec.describe ShinyCMS::S3Config, type: :model do
  let( :bucket ) { 'shinycms-tests' }
  let( :region ) { 'eu-test-1'      }

  before do
    allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_SECRET_ACCESS_KEY' ).and_return 'test'

    allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_BUCKET' ).and_return bucket
    allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_REGION' ).and_return region
  end

  context 'when all S3 config details are present in ENV' do
    before do
      allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_ACCESS_KEY_ID' ).and_return 'test'
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

        allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_BASE_URL' ).and_return nil
        allow( ENV ).to receive( :[] ).with( 'SHINYCMS_USE_HTTPS'    ).and_return nil

        expect( s3_config.base_url ).to eq "http://#{bucket}.s3.#{region}.amazonaws.com"
      end
    end
  end

  context 'when any item of S3 config is missing from ENV' do
    before do
      allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_ACCESS_KEY_ID' ).and_return nil
    end

    describe '.get( label )' do
      it 'returns nil' do
        s3_config = described_class.get( :feeds )

        expect( s3_config ).to be nil
      end
    end
  end
end
