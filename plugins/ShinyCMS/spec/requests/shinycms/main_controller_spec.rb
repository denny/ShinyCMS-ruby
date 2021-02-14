# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for main site base controller
RSpec.describe ShinyCMS::MainController, type: :request do
  describe 's3 helper methods' do
    describe 'feed_url()' do
      it 'includes an S3 feed URL in the page when S3 config is present' do
        create :top_level_page

        bucket = 'main-controller-test'
        region = 'a-test-1'

        allow_any_instance_of( described_class ).to receive( :aws_s3_feeds_bucket ).and_return bucket
        allow_any_instance_of( described_class ).to receive( :aws_s3_feeds_region ).and_return region

        allow_any_instance_of( described_class ).to receive( :aws_s3_feeds_access_key_id ).and_return 'test'
        allow_any_instance_of( described_class ).to receive( :aws_s3_feeds_secret_access_key ).and_return 'test'

        get main_app.root_path

        expect( response.body ).to include "http://#{bucket}.s3.#{region}.amazonaws.com/feeds/atom/blog.xml"
      end
    end
  end
end
