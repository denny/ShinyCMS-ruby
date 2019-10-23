# Common behaviour for names, titles, and slugs, for pages and page sections
module NameTitleSlug
  extend ActiveSupport::Concern

  # Allowed characters for slugs: a-z A-Z 0-9 . _ -
  SLUG_REGEX = %r{[-\.\w]+}.freeze
  private_constant :SLUG_REGEX
  ANCHORED_SLUG_REGEX = %r{\A#{SLUG_REGEX}\z}.freeze
  private_constant :ANCHORED_SLUG_REGEX

  included do
    validates :name, presence:  true
    validates :title, presence: true
    validates :slug, presence:  true
    validates :slug, safe_slug: true
    validates :slug, format:    ANCHORED_SLUG_REGEX
    validates :slug, uniqueness: {
      scope: :section,
      message: I18n.t( 'slug_unique' )
    }
  end

  class_methods do
    def slugify( slug )
      slug.replace! %r{\s+}, '-'
      slug.remove!  %r{[^\-\.\w]}
      slug.replace! %r{\-+}, '-'
    end
  end
end
