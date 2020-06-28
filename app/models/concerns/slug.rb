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

    # rubocop:disable Style/RedundantSelf
    def generate_slug
      return unless self.respond_to?( :title ) && title.present?

      self.slug = title.parameterize
    end
    # rubocop:enable Style/RedundantSelf
  end
end
