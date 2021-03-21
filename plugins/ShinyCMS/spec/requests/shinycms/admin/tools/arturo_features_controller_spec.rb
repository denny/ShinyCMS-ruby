# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe Arturo::FeaturesController, type: :request do
  describe 'GET /admin/tools/arturo' do
    context 'when logged in as a feature flag admin' do
      before do
        admin = create :feature_flags_admin
        sign_in admin
      end

      it 'loads the page' do
        get arturo_engine.features_path

        expect( response ).to have_http_status :ok
      end
    end

    context 'when logged in as a news admin' do
      before do
        admin = create :news_admin
        sign_in admin
      end

      it 'returns a 403 Forbidden status' do
        get arturo_engine.features_path

        expect( response ).to have_http_status :forbidden
      end
    end
  end
end
