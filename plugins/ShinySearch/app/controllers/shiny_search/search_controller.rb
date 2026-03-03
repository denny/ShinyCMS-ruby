# frozen_string_literal: true

# ShinySearch plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinySearch
  # Main site controller for ShinySearch plugin for ShinyCMS
  class SearchController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    include ShinySearch::MainSiteHelper

    before_action :check_feature_flags
    before_action :stash_query_string

    SEARCH_BACKENDS = %w[ algolia pg ].freeze
    private_constant :SEARCH_BACKENDS

    def index
      return unless @query

      backend = search_params[ :engine ].presence || setting( :default_search_backend )
      backend = nil unless SEARCH_BACKENDS.include? backend

      @pagy, @results = perform_search( backend )
    end

    private

    def perform_search( backend )
      return pg_search if pg_search_is_enabled? && backend == 'pg'

      return algolia_search if algolia_search_is_enabled? && backend == 'algolia'

      unless at_least_one_search_backend_is_enabled?
        Rails.logger.error 'Search feature is enabled, but no search back-ends are enabled'
      end

      [ nil, [] ] # Minimum required to render the 'no results' page
    end

    def at_least_one_search_backend_is_enabled?
      algolia_search_is_enabled? || pg_search_is_enabled?
    end

    def pg_search
      @search_backend = :pg

      # TODO: investigate performance of this with a large resultset
      pagy, results = pagy_array(
        PgSearch.multisearch( @query ).includes( :searchable ).collect( &:searchable )
      )

      [ pagy, results ]
    end

    def algolia_search
      @search_backend = :algolia

      # TODO: get results from Algolia search API

      [ nil, [] ]
    end

    def stash_query_string
      @query = search_params[ :query ] || search_params[ :q ]
    end

    def search_params
      params.permit( :query, :q, :engine, :page, :count, :items, :per )
    end

    def check_feature_flags
      enforce_feature_flags :search
    end
  end
end
