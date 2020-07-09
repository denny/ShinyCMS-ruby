# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/search_controller.rb
# Purpose:   Controller for search features on a ShinyCMS-powered site
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class SearchController < ApplicationController
  include SearchHelper

  before_action :check_feature_flags
  before_action :stash_query_string

  def index
    return unless @query

    @page_num = params[ :page ] || 1
    @per_page = Setting.get( :search_results_per_page ) || 20

    if use_pg_search?
      pg_search
    elsif algolia_search_is_enabled?
      algolia_search
    end
  end

  private

  def pg_search
    @pageable = PgSearch.multisearch( @query )
                        .includes( :searchable )
                        .page( @page_num )
                        .per( @per_page )
    @results = @pageable.map( &:searchable )
  end

  def algolia_search
    # TODO: get results from Algolia search API
    @results = []
  end

  def stash_query_string
    @query = params[:query]
  end

  def check_feature_flags
    enforce_feature_flags :search
  end
end
