# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Base model class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.models_with_demo_data
    [ core_models_with_demo_data + ShinyPlugin.models_with_demo_data ].flatten.sort
  end

  def self.core_models_with_demo_data
    descendants.select { |model| model.respond_to?( :dump_for_demo? ) }.collect( &:name ).sort
  end
end
