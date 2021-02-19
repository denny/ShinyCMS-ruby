# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyCMS::S3Config model
RSpec.describe ShinyCMS::S3Config, type: :model do
  describe '.base_url' do
    context 'when S3 config is present' do
      it 'generates an S3 base URL' do
        s3_config = described_class.new( :feeds )

        bucket = 'atom-feed-tests'
        region = 'test'

        allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_SECRET_ACCESS_KEY' ).and_return 'test'
        allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_ACCESS_KEY_ID' ).and_return 'test'

        allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_BUCKET' ).and_return bucket
        allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_REGION' ).and_return region

        allow( ENV ).to receive( :[] ).with( 'AWS_S3_FEEDS_BASE_URL' ).and_return nil
        allow( ENV ).to receive( :[] ).with( 'SHINYCMS_USE_HTTPS'    ).and_return nil

        expect( s3_config.base_url ).to eq "http://#{bucket}.s3.#{region}.amazonaws.com"
      end
    end
  end
end
