# frozen_string_literal: true

# Model class for blogs (which are a collection of blog posts)
class Blog < ApplicationRecord
  belongs_to :user, inverse_of: :blogs
  alias_attribute :owner, :user

  has_many :all_posts,
           class_name: 'BlogPost',
           foreign_key: 'blog_id',
           inverse_of: 'blog',
           dependent: :restrict_with_error

  # Allowed characters for slugs: a-z A-Z 0-9 . _ -
  SLUG_REGEX = %r{[-_\.a-zA-Z0-9]+}.freeze
  private_constant :SLUG_REGEX
  ANCHORED_SLUG_REGEX = %r{\A#{SLUG_REGEX}\z}.freeze
  private_constant :ANCHORED_SLUG_REGEX

  validates :name,  presence: true
  validates :title, presence: true
  validates :slug,  presence: true
  validates :slug,  format:   ANCHORED_SLUG_REGEX

  before_validation :generate_title, if: -> { title.blank? && name.present? }
  before_validation :generate_slug,  if: -> { slug.blank?  && name.present? }

  # Configure default count-per-page for pagination
  paginates_per 20

  # Instance methods

  def posts
    all_posts.where( hidden: false )
    # TODO: figure out why this is b0rked
    # .where( 'posted_at <= current_timestamp' )
  end

  def hidden_posts
    all_posts.where( hidden: true )
  end

  def find_post( year, month, slug )
    posts_for_month( year, month ).find_by( slug: slug )
  end

  def posts_for_month( year, month )
    start_date = Date.new( year.to_i, month.to_i, 1 )
    end_date = start_date + 1.month
    posts.where( posted_at: start_date..end_date ).order( :posted_at )
  end

  def posts_for_year( year )
    start_date = Date.new( year.to_i, 1, 1 )
    end_date = start_date + 1.year
    posts.where( posted_at: start_date..end_date ).order( :posted_at )
  end

  def recent_posts( page_num = 1 )
    posts.order( posted_at: :desc ).page( page_num )
  end

  def generate_title
    self.title = name.titlecase
  end

  def generate_slug
    self.slug = name.parameterize
  end

  # Class methods

  def self.multiple_blogs_mode?
    Rails.application.config.multiple_blogs_mode == true
  end
end
