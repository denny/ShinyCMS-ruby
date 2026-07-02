# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  module Admin
    # Allow admin controllers in other plugins to access some List data
    module WithLists
      extend ActiveSupport::Concern

      included do
        def recently_updated_lists
          ShinyLists::List.recently_updated
        end
      end
    end
  end
end
