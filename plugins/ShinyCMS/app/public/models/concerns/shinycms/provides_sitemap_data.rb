# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Models with content that should/could be included in a sitemap (the SEO type, currently at least)
  module ProvidesSitemapData
    extend ActiveSupport::Concern

    included do
      scope :recent_updates, -> { order( updated_at: :desc ) }
    end

    class_methods do
      # Default method to return something vaguely/generically appropriate. Models
      # can and should override this if they want to do something more interesting!
      def sitemap_items
        # :nocov:
        visible.recent_updates.readonly
        # :nocov:
      end
    end
  end
end
