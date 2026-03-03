# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for password-related features on main site
RSpec.describe ShinyCMS::PasswordReportAction, type: :request do
  describe 'GET /account/password/report/Hunter2' do
    it 'returns a JSON assessment (score and suggestions) for the proposed password' do
      get shinycms.password_report_path( 'Hunter2' )

      expect( response ).to have_http_status :ok

      result = response.parsed_body

      expect( result['score'] ).to eq 0
      expect( result['crack_time_display'] ).to eq 'instant'
      expect( result['feedback']['suggestions'] ).to include 'Add another word or two. Uncommon words are better.'
    end
  end
end
