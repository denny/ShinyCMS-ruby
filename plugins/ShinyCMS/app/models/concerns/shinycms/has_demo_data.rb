# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Models that supply demo site data
  module ShinyDemoDataProvider
    extend ActiveSupport::Concern

    class_methods do
      def demo_data?
        true
      end

      # Default restore order, for anything that doesn't care
      def demo_data_position
        1
      end
    end
  end
end
