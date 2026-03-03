# frozen_string_literal: true

# ShinySearch plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinySearch
  # Helper methods for working with search back-ends
  module Searchable
    extend ActiveSupport::Concern

    class_methods do
      def searchable_by( *searchable_attributes )
        algolia_search_on( searchable_attributes ) if algolia_search_is_enabled?
        pg_search_on( searchable_attributes )      if pg_search_is_enabled?
      end

      def algolia_search_on( searchable_attributes )
        include AlgoliaSearch

        algoliasearch unless: :hidden?, per_environment: true do
          attributes searchable_attributes
        end
      end

      def pg_search_on( searchable_attributes )
        include PgSearch::Model

        multisearchable against: searchable_attributes, unless: :hidden?
      end

      def algolia_search_is_enabled?
        ENV.fetch( 'ALGOLIASEARCH_APPLICATION_ID', nil ).present?
      end

      def pg_search_is_enabled?
        ENV.fetch( 'DISABLE_PG_SEARCH', nil )&.downcase != 'true'
      end
    end
  end
end
