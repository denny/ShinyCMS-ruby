# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Base model class
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    # Don't ask me why Rails is failing to use its own methods consistently...
    def self.table_name
      name.tableize.sub( '/', '_' )
    end

    def self.models_with_demo_data
      [ core_models_with_demo_data + Plugin.models_with_demo_data ].flatten
    end

    def self.core_models_with_demo_data
      descendants.select { |model| model.respond_to? :dump_for_demo? }
    end
  end
end
