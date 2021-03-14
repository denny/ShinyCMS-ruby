# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyCMS error handlers
RSpec.describe ShinyCMS::ErrorsController, type: :request do
  describe 'GET /wp-login.php (or any URL ending in .php)', :production_error_responses do
    it 'returns a 400 (Bad Request) error - headers only, to keep it light' do
      get '/wp-login.php'

      expect( response ).to have_http_status :bad_request

      expect( response.body ).to be_blank
    end
  end

  describe 'GET /no-such-path', :production_error_responses do
    it 'returns our Not Found page, with a 404 status' do
      get '/no-such-path'

      expect( response ).to have_http_status :not_found
    end
  end

  describe 'GET /test/500', :production_error_responses do
    it 'returns our error page, with a 500 status' do
      get '/test/500'

      expect( response ).to have_http_status :internal_server_error
    end
  end
end
