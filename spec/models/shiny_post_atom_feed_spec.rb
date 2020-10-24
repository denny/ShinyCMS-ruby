# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyPostAtomFeed model
RSpec.describe ShinyPostAtomFeed, type: :model do
  context 'instance methods' do
    describe 'ENV fetcher methods' do
      it 'reads the ENV vars' do
        bucket = 'shinycms-feed-tests'
        ENV[ 'AWS_S3_FEEDS_BUCKET' ] = bucket

        feeder = ShinyPostAtomFeed.new( :blog )

        expect(  feeder.__send__( :aws_s3_feeds_bucket ) ).to eq bucket
        region = feeder.__send__( :aws_s3_feeds_region )
        expect(  feeder.__send__( :aws_s3_base_url     ) ).to eq "https://#{bucket}.s3.#{region}.amazonaws.com"

        expect(  feeder.__send__( :aws_s3_feeds_secret_access_key ) ).to eq nil
        expect(  feeder.__send__( :aws_s3_feeds_access_key_id     ) ).to eq nil

        ENV[ 'AWS_S3_FEEDS_BUCKET' ] = ''
      end
    end
  end
end
