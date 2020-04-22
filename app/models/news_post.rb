# frozen_string_literal: true

# Model class for news posts
class NewsPost < ApplicationRecord
  belongs_to :user, inverse_of: :news_posts
  alias_attribute :author, :user

  has_one :discussion, as: :resource, dependent: :destroy

  delegate :hidden, to: :discussion, allow_nil: true, prefix: true
  delegate :locked, to: :discussion, allow_nil: true, prefix: true

  algolia_searchable

  # TODO: lots of duplication going on here/blog posts/pages; to be concerned
  # Allowed characters for slugs: a-z A-Z 0-9 . _ -
  SLUG_REGEX = %r{[-_\.a-zA-Z0-9]+}.freeze
  private_constant :SLUG_REGEX
  ANCHORED_SLUG_REGEX = %r{\A#{SLUG_REGEX}\z}.freeze
  private_constant :ANCHORED_SLUG_REGEX

  validates :user_id, presence: true
  validates :title,   presence: true
  validates :slug,    presence: true
  validates :slug,    format:   ANCHORED_SLUG_REGEX
  validates :body,    presence: true

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  # Configure default count-per-page for pagination
  paginates_per 20

  # Add tagging features
  acts_as_taggable

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

  # Class methods

  def self.find_post( year, month, slug )
    posts_for_month( year, month ).find_by( slug: slug )
  end

  def self.posts_for_year( year )
    start_date = Date.new( year.to_i, 1, 1 )
    end_date = start_date + 1.year
    where( posted_at: start_date..end_date ).order( :posted_at )
  end

  def self.posts_for_month( year, month )
    start_date = Date.new( year.to_i, month.to_i, 1 )
    end_date = start_date + 1.month
    where( posted_at: start_date..end_date ).order( :posted_at )
  end

  def self.recent_posts( page_num = 1 )
    where( hidden: false ).order( posted_at: :desc ).page( page_num )
  end
end
