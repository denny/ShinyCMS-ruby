# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Base model class
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
