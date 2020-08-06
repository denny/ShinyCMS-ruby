# frozen_string_literal: true

# Application Record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def human_name
    name = self.class.name.underscore
    return name.humanize.downcase unless I18n.exists?( "element_types.#{name}" )

    I18n.t( "element_types.#{name}" )
  end

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
    ENV['ALGOLIASEARCH_APPLICATION_ID'].present?
  end

  def self.pg_search_is_enabled?
    ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
  end

  def self.dump_for_demo?
    false
  end
end
