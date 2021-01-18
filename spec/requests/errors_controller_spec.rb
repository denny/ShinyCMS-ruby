# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyCMS error handlers
RSpec.describe ErrorsController, type: :request do
  describe 'GET /no-such-path' do
    it 'returns our Not Found page, with a 404 status' do
      get '/no-such-path'

      expect( response ).to have_http_status :not_found
    end
  end

  describe 'GET /errors/test500', :production_error_responses do
    it 'returns our error page, with a 500 status' do
      get '/errors/test500'

      expect( response ).to have_http_status :internal_server_error
    end
  end
end
