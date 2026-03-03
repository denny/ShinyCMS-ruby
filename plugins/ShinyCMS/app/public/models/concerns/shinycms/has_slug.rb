# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for URL slugs
  module HasSlug
    extend ActiveSupport::Concern

    # Allowed characters for slugs: a-z A-Z 0-9 . _ -
    SLUG_REGEX = %r{\A[-_.a-zA-Z0-9]+\z}
    private_constant :SLUG_REGEX

    included do
      validates :slug_base, presence: true

      validates :slug, presence: true, format: SLUG_REGEX

      before_validation :generate_slug, if: -> { slug.blank? }

      # Models that include this concern must provide a .slug_base method
      # (probably an alias to their .name or .title method)
      def generate_slug
        self.slug = slug_base.parameterize
      end
    end
  end
end
