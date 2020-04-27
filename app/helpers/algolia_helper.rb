# frozen_string_literal: true

# Utility functions for dealing with Algolia (Search as a Service provider)
module AlgoliaHelper
  def algolia_is_enabled?
    AlgoliaSearch&.configuration&.present?
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
