# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Used to mark models which supply data to the demo site data dump process
  module ShinyDemoDataProvider
    extend ActiveSupport::Concern

    class_methods do
      def dump_for_demo?
        true
      end
    end
  end
end
