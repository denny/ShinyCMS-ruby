# frozen_string_literal: true

# ============================================================================
# Project:   ShinySearch plugin for ShinyCMS (Ruby version)
# File:      plugin/ShinySearch/app/helpers/search_helper.rb
# Purpose:   Helper methods
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinySearch
  # Utility functions for dealing with pg_multisearch and Algolia (Search as a Service provider)
  module SearchHelper
    def pg_search_is_enabled?
      ENV['DISABLE_PG_SEARCH'].blank?
    end

    def algolia_search_is_enabled?
      ENV['ALGOLIASEARCH_APPLICATION_ID'].present?
    end

    # Algolia have a free plan for low-usage non-commercial sites. It requires you
    # to display their logo on search result pages. If you are using a paid plan
    # and you want to hide their logo, set ALGOLIASEARCH_USING_PAID_PLAN to 'Yes'.
    def using_paid_algolia_plan?
      ENV[ 'ALGOLIASEARCH_USING_PAID_PLAN' ].presence&.downcase == 'yes'
    end

    def using_free_algolia_plan?
      !using_paid_algolia_plan?
    end
  end
end
