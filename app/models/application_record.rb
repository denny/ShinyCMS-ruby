# frozen_string_literal: true

# Application Record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.models_with_demo_data
    [ core_models_with_demo_data + Plugin.models_with_demo_data ].flatten.sort
  end

  def self.core_models_with_demo_data
    model_names = []
    descendants.each do |model|
      model_names << model.name if model.respond_to? :dump_for_demo?
    end
    model_names
  end
end
