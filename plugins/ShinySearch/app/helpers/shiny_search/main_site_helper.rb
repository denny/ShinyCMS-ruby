# frozen_string_literal: true

# ShinySearch plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinySearch
  # Utility functions for dealing with pg_multisearch and Algolia (Search as a Service provider)
  module MainSiteHelper
    def pg_search_is_enabled?
      ENV.fetch( 'DISABLE_PG_SEARCH', 'false' ).downcase != 'true'
    end

    def algolia_search_is_enabled?
      ENV.fetch( 'ALGOLIASEARCH_APPLICATION_ID', nil ).present?
    end

    def display_algolia_logo?
      algolia_search_is_enabled? && using_free_algolia_plan?
    end

    # Algolia have a free plan for low-usage non-commercial sites. It requires you
    # to display their logo on search result pages. If you are using a paid plan
    # and you want to hide their logo, set ALGOLIASEARCH_USING_PAID_PLAN to 'Yes'.
    def using_paid_algolia_plan?
      ENV.fetch( 'ALGOLIASEARCH_USING_PAID_PLAN', 'false' ).downcase == 'true'
    end

    def using_free_algolia_plan?
      !using_paid_algolia_plan?
    end
  end
end
