# frozen_string_literal: true

# Application Record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.dump_for_demo?
    false
  end

  def self.models_with_demo_data
    [ core_models_with_demo_data + plugin_models_with_demo_data ].flatten.sort
  end

  def self.core_models_with_demo_data
    descendants.select( &:dump_for_demo? ).map( &:to_s )
  end

  def self.plugin_models_with_demo_data
    models = []
    Plugin.with_models.each do |plugin|
      models << plugin.base_model.descendants.select( &:dump_for_demo? ).map( &:to_s )
    end
    models
  end
end
