# frozen_string_literal: true

# Adds methods for working with search back-ends
module ShinySearchConcern
  extend ActiveSupport::Concern

  included do
    def self.algolia_search_on( searchable_attributes )
      return unless algolia_search_is_enabled?

      include AlgoliaSearch

      algoliasearch unless: :hidden?, per_environment: true do
        attributes searchable_attributes
      end
    end

    def self.pg_search_on( searchable_attributes )
      return unless pg_search_is_enabled?

      include PgSearch::Model

      multisearchable against: searchable_attributes, unless: :hidden?
    end

    def self.algolia_search_is_enabled?
      Setting.get( :search_enabled_algolia ) == 'true'
    end

    def self.pg_search_is_enabled?
      Setting.get( :search_enabled_postgres ) == 'true'
    end
  end
end
