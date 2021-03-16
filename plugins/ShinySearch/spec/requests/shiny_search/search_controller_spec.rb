# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShinySearch::SearchController, type: :request do
  let( :profile ) do
    test_user = create :user
    test_user.profile.update!( public_name: 'Success' )
    test_user.profile
  end

  describe 'GET /search' do
    it 'displays the search form' do
      get shiny_search.search_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_search.search.new.title' )
    end
  end

  context 'when no search back-ends are enabled' do
    describe 'GET /search?query=Success' do
      it 'tells the user no results were found, and logs an error' do
        allow( Rails.logger ).to receive( :error ).with(
          'Search feature is enabled, but no search back-ends are enabled'
        )

        get shiny_search.search_path, params: { query: 'Wot No Backend?' }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_search.search.results.title', query: 'Wot No Backend?' )
        expect( response.body ).to have_css 'p', text: I18n.t( 'shiny_search.search.no_results.no_results' )
      end
    end
  end

  context 'when the pg_search backend is enabled' do
    before do
      ShinyCMS::FeatureFlag.enable :user_profiles

      allow( ENV ).to receive( :fetch ).and_return nil

      allow( ENV ).to receive( :fetch ).with( 'DISABLE_PG_SEARCH', 'false' ).and_return 'false'

      allow( ENV ).to receive( :fetch ).with( 'SHINYCMS_THEME', nil ).and_return 'TEST'

      ShinyProfiles::Profile.pg_search_on %i[ username public_name public_email bio location postcode ]

      profile
    end

    describe 'GET /search?engine=pg&query=Success' do
      it 'displays the search results, explicitly using the pg_search back-end' do
        get shiny_search.search_path, params: { engine: 'pg', query: 'Success' }

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'shiny_search.search.results.title', query: 'Success' )
        expect( response.body ).to     have_link profile.name, href: shiny_profiles.profile_path( profile.username )
        expect( response.body ).not_to have_css 'p', text: I18n.t( 'shiny_search.search.no_results.no_results' )
      end
    end

    describe 'GET /search?query=Success' do
      it 'displays the search results, using the default search back-end (pg_search)' do
        get shiny_search.search_path, params: { query: 'Success' }

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'shiny_search.search.results.title', query: 'Success' )
        expect( response.body ).to     have_link profile.name, href: shiny_profiles.profile_path( profile.username )
        expect( response.body ).not_to have_css 'p', text: I18n.t( 'shiny_search.search.no_results.no_results' )
      end
    end

    describe 'GET /search?query=FAIL' do
      it 'displays an appropriate message when there are no matching results' do
        get "#{shiny_search.search_path}?query=FAIL"

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'shiny_search.search.results.title', query: 'FAIL' )
        expect( response.body ).to     have_css 'p', text: I18n.t( 'shiny_search.search.no_results.no_results' )
        expect( response.body ).not_to have_link profile.name, href: shiny_profiles.profile_path( profile.username )
      end
    end
  end

  context 'when the Algolia Search backend is enabled' do
    before do
      ShinyCMS::FeatureFlag.enable :user_profiles

      allow( ENV ).to receive( :fetch ).and_return nil

      allow( ENV ).to receive( :fetch ).with( 'SHINYCMS_THEME',                nil     ).and_return 'TEST'
      allow( ENV ).to receive( :fetch ).with( 'ALGOLIASEARCH_APPLICATION_ID',  nil     ).and_return 'fake-id'
      allow( ENV ).to receive( :fetch ).with( 'ALGOLIASEARCH_USING_PAID_PLAN', 'false' ).and_return 'false'
      allow( ENV ).to receive( :fetch ).with( 'DISABLE_PG_SEARCH',             'false' ).and_return 'false'

      WebMock.enable!

      AlgoliaSearch.configuration = { application_id: 'fake-id', api_key: 'fake-key' }

      ShinyProfiles::Profile.algolia_search_on %i[ username public_name public_email bio location postcode ]

      profile
    end

    after do
      WebMock.disable!
    end

    describe 'GET /search?engine=algolia&query=Success' do
      it 'displays the search results, using the Algolia search back-end' do
        get shiny_search.search_path, params: { engine: 'algolia', query: 'Success' }

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'shiny_search.search.results.title', query: 'Success' )
        # TODO
        # expect( response.body ).to     have_link profile.name, href: shiny_profiles.profile_path( profile.username )
        # expect( response.body ).not_to have_css 'p', text: I18n.t( 'shiny_search.search.no_results.no_results' )
      end
    end
  end
end
