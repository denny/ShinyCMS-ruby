# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for main site base controller
RSpec.describe MainController, type: :request do
  describe 'helper methods' do
    describe 'feed_url()' do
      it 'returns an appropriate feed URL when the AWS S3 ENV vars are set' do
        create :top_level_page

        ENV['AWS_S3_FEEDS_BUCKET'] = 'test_bucket'
        ENV['AWS_S3_FEEDS_REGION'] = 'eu-test-1'

        get main_app.root_path

        ENV['AWS_S3_FEEDS_BUCKET'] = nil
        ENV['AWS_S3_FEEDS_REGION'] = nil

        expect( response.body ).to include 'http://test_bucket.s3.eu-test-1.amazonaws.com/feeds/atom/blog.xml'
      end
    end
  end
end
