# Model class for blog posts
class BlogPost < ApplicationRecord
  belongs_to :blog
  belongs_to :author, class_name: 'User',
                      foreign_key: 'user_id',
                      inverse_of: 'blog_posts'

  # Allowed characters for slugs: a-z A-Z 0-9 . _ -
  SLUG_REGEX = %r{[-_\.a-zA-Z0-9]+}.freeze
  private_constant :SLUG_REGEX
  ANCHORED_SLUG_REGEX = %r{\A#{SLUG_REGEX}\z}.freeze
  private_constant :ANCHORED_SLUG_REGEX

  validates :blog_id, presence: true
  validates :user_id, presence: true
  validates :title,   presence: true
  validates :slug,    presence: true
  validates :slug,    format:   ANCHORED_SLUG_REGEX
  validates :body,    presence: true

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  # Configure default count-per-page for pagination
  paginates_per 20

  # Instance methods

  def generate_slug
    self.slug = title.parameterize
  end

  def posted_month
    posted_at.strftime( '%m' )
  end

  def posted_year
    posted_at.strftime( '%Y' )
  end

  def teaser( paragraphs: 3 )
    paras = body.split %r{</p>[^<]*<p>}i
    return paras[ 0..( paragraphs - 1 ) ].join( "</p>\n<p>" ) if paras.size > 1

    paras = body.split %r{<br ?/?><br ?/?>}i
    return paras[ 0..( paragraphs - 1 ) ].join "\n<br><br>\n" if paras.size > 1

    body
  end
end
