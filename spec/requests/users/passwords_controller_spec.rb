# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for password-related features on main site
RSpec.describe Users::PasswordsController, type: :request do
  describe 'GET /account/password/test/Hunter2' do
    it 'returns a JSON assessment (score and suggestions) for the proposed password' do
      get test_password_path( 'Hunter2' )

      expect( response ).to have_http_status :ok

      result = JSON.parse( response.body )

      expect( result['score'] ).to eq 0
      expect( result['crack_time_display'] ).to eq 'instant'
      expect( result['feedback']['suggestions'] ).to include 'Add another word or two. Uncommon words are better.'
    end
  end
end
