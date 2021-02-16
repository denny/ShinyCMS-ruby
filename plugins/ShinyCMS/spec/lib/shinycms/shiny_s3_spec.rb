# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for AWS S3 helper methods
RSpec.describe ShinyCMS::ShinyS3, type: :module do
  describe 'aws_s3_feeds_region' do
    it 'returns the value of the corresponding ENV var' do
      ENV[ 'AWS_S3_FEEDS_REGION' ] = 'a-test-1'

      test = ShinyCMS::MainController.new

      result = test.__send__( :aws_s3_feeds_region )

      expect( result ).to eq 'a-test-1'
    end
  end

  describe 'aws_s3_feeds_access_key_id' do
    it 'returns nil (not an empty string) when the corresponding ENV var is not set' do
      test = ShinyCMS::MainController.new

      result = test.__send__( :aws_s3_feeds_access_key_id )

      expect( result ).not_to eq ''
      expect( result ).to be_falsey
      expect( result ).to be nil
    end
  end
end
