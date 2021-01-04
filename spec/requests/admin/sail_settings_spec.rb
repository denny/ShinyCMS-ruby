# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the settings features in the admin area provided by the Sails engine
RSpec.describe 'Sail settings engine', type: :request do
  before do
    admin = create :settings_admin
    sign_in admin
  end

  describe 'GET /admin/settings' do
    it 'fetches the settings page' do
      get '/admin/settings'

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.site_settings.index.title' ).titlecase
    end
  end
end
