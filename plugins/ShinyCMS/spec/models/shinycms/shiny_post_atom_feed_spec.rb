# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyPostAtomFeed model
RSpec.describe ShinyCMS::ShinyPostAtomFeed, type: :model do
  describe 'instance methods' do
    describe 'S3 helper methods' do
      it 'generates an S3 base url when S3 config is present' do
        feeder = described_class.new( :blog )

        bucket = 'atom-feed-tests'
        region = 'test'

        allow( feeder ).to receive( :aws_s3_feeds_bucket ).and_return bucket
        allow( feeder ).to receive( :aws_s3_feeds_region ).and_return region

        allow( feeder ).to receive( :aws_s3_feeds_access_key_id ).and_return 'test'
        allow( feeder ).to receive( :aws_s3_feeds_secret_access_key ).and_return 'test'

        expect( feeder.__send__( :feeds_base_url ) ).to eq "http://#{bucket}.s3.#{region}.amazonaws.com"
      end
    end
  end
end
