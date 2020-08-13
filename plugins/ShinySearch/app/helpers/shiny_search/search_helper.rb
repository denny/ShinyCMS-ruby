# frozen_string_literal: true

# Utility functions for dealing with pg_multisearch and Algolia (Search as a Service provider)
module SearchHelper
  def pg_search_is_enabled?
    ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
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
