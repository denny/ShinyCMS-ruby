# frozen_string_literal: true

# Common behaviour for URL slugs
module Slug
  extend ActiveSupport::Concern

  # Allowed characters for slugs: a-z A-Z 0-9 . _ -
  SLUG_REGEX = %r{\A[-_.a-zA-Z0-9]+\z}.freeze
  private_constant :SLUG_REGEX

  included do
    validates :slug, presence: true, format: SLUG_REGEX

    before_validation :generate_slug, if: -> { slug.blank? }

    def generate_slug
      if title.present?
        self.slug = title.parameterize
      elsif name.present?
        self.slug = name.parameterize
      end
    end
  end
end
