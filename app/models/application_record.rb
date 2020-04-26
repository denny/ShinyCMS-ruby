# frozen_string_literal: true

# Application Record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def human_name
    name = self.class.name.underscore
    return name.humanize.downcase unless I18n.exists?( "content_types.#{name}" )

    I18n.t( "content_types.#{name}" )
  end

  def self.algolia_is_enabled?
    AlgoliaSearch&.configuration&.present?
  end

  def self.algolia_searchable
    return unless algolia_is_enabled?

    include AlgoliaSearch

    algoliasearch unless: :hidden?, per_environment: true do
      # TODO: all attributes will be sent - is that what we want?
      # TODO: what happens here when the value of .hidden changes?
    end
  end
end
