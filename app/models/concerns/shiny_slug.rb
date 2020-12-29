# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Common behaviour for URL slugs
module ShinySlug
  extend ActiveSupport::Concern

  # Allowed characters for slugs: a-z A-Z 0-9 . _ -
  SLUG_REGEX = %r{\A[-_.a-zA-Z0-9]+\z}
  private_constant :SLUG_REGEX

  included do
    validates :slug, presence: true, format: SLUG_REGEX

    before_validation :generate_slug, if: -> { slug.blank? }

    # rubocop:disable Style/RedundantSelf
    def generate_slug
      if self.respond_to?( :name ) && name.present?
        self.slug = name.parameterize
      elsif self.respond_to?( :title ) && title.present?
        self.slug = title.parameterize
      end
    end
    # rubocop:enable Style/RedundantSelf
  end
end
