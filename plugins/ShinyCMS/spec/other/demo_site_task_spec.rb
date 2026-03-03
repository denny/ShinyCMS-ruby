# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the supporting lib for the demo site rake tasks (in lib/tasks/support/)
RSpec.describe 'DemoSiteTask', type: :helper do
  describe 'munge_user_id' do
    context 'when it finds user_id: 1 in a create statement' do
      it 'replaces it with the admin ID variable' do
        input = <<~INPUT
          ShinyNews::Post.create!([{id: 1, title: "No news is good news?", slug: "no-news", body: "<p>Insert imaginative demo content here...</p>\r\n", show_on_site: true, user_id: 1, posted_at: "2020-05-14 14:06:33", deleted_at: nil}])
        INPUT
        expected = <<~EXPECTED
          ShinyNews::Post.create!([{id: 1, title: "No news is good news?", slug: "no-news", body: "<p>Insert imaginative demo content here...</p>\r\n", show_on_site: true, user_id: @shiny_admin.id, posted_at: "2020-05-14 14:06:33", deleted_at: nil}])
        EXPECTED

        result = described_class.munge_user_id_in( input )

        expect( result ).to eq expected
      end
    end
  end

  describe 'models_with_demo_data' do
    it 'returns an array(ish) of models from core and feature plugins' do
      demo_models = described_class.models_with_demo_data

      expect( demo_models ).to be_an Enumerable

      demo_model_names = demo_models.collect( &:name )

      expect( demo_model_names ).to include 'ShinyAccess::Group'
      expect( demo_model_names ).to include 'ShinyCMS::Comment'
      expect( demo_model_names ).to include 'ShinyNews::Post'
      expect( demo_model_names ).to include 'ShinyProfiles::Link'
    end

    it 'does not include User data' do
      demo_models = described_class.models_with_demo_data

      demo_model_names = demo_models.collect( &:name )

      expect( demo_model_names ).not_to include 'ShinyCMS::User'
    end
  end

  describe 'create_statements_for( model )' do
    context 'when the model holds no data' do
      it 'returns an empty string' do
        expect( described_class.create_statements_for( ShinyCMS::VotableIP ) ).to eq ''
      end
    end
  end
end
