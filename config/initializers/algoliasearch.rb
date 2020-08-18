# frozen_string_literal: true

# Configuration for Algolia (Search as a Service)

if ENV['ALGOLIASEARCH_APPLICATION_ID']
  AlgoliaSearch.configuration = {
    application_id: ENV['ALGOLIASEARCH_APPLICATION_ID'],
    api_key: ENV['ALGOLIASEARCH_API_KEY'],
    pagination_backend: :kaminari
  }
end
