# Model class for blog posts
class BlogPost < ApplicationRecord
  belongs_to :user
  belongs_to :blog

  delegate :month, to: :posted_at
  delegate :year,  to: :posted_at

  # Allowed characters for slugs: a-z A-Z 0-9 . _ -
  SLUG_REGEX = %r{[-_\.a-zA-Z0-9]+}.freeze
  private_constant :SLUG_REGEX
  ANCHORED_SLUG_REGEX = %r{\A#{SLUG_REGEX}\z}.freeze
  private_constant :ANCHORED_SLUG_REGEX

  validates :title, presence: true
  validates :slug,  presence: true
  validates :slug,  format:   ANCHORED_SLUG_REGEX

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  # Configure default count-per-page for pagination
  paginates_per 20

  # Instance methods

  def generate_slug
    self.slug = title.parameterize
  end
end
