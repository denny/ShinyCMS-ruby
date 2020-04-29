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
  before_action :check_feature_flags
  before_action :stash_query_string

  def index
    warn ">>>>>>>>>>>>>>>>>>>>>#{@query}<<<<"
    return unless @query

    # TODO: write some code ;)
    @results = User.where( display_name: @query )
  end

  private

  def stash_query_string
    @query = params[:query]
  end

  def check_feature_flags
    enforce_feature_flags :search
  end
end
