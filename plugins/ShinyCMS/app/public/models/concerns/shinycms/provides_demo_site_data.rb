# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Models that supply data for the demo site
  module ProvidesDemoSiteData
    extend ActiveSupport::Concern

    class_methods do
      # Set the order in which data is loaded by `rails shinycms:demo:load`.
      # Defaults to 'in the first batch', i.e. no dependencies on other data.
      #
      # Override per model with a class method `my_demo_data_position`, that
      # returns an integer higher than any of the models it depends on.
      def demo_data_position
        try( :my_demo_data_position ) || 1
      end
    end
  end
end
