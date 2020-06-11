# frozen_string_literal: true

# Model class for news posts
class NewsPost < ApplicationRecord
  include Slug
  include Teaser

  belongs_to :user, inverse_of: :news_posts

  alias_attribute :author, :user

  has_one :discussion, as: :resource, dependent: :destroy

  delegate :hidden, to: :discussion, allow_nil: true, prefix: true
  delegate :locked, to: :discussion, allow_nil: true, prefix: true

  before_validation :set_posted_at, if: -> { posted_at.blank? }

  validates :user_id, presence: true
  validates :title,   presence: true
  validates :body,    presence: true
  validates :slug,    unique_in_collection: {
    collection: ->( record ) { record.posts_this_month }
  }

  # Configure default count-per-page for pagination
  paginates_per 20

  # Add tagging features
  acts_as_taggable

  # Instance methods

  def path( anchor: nil )
    url_helpers.view_news_post_path(
      posted_year, posted_month, slug, anchor: anchor
    )
  end

  def set_posted_at
    self.posted_at = Time.zone.now if posted_at.blank?
  end

  def posted_month
    posted_at.strftime( '%m' )
  end

  def posted_year
    posted_at.strftime( '%Y' )
  end

  def posts_this_month
    start_date = posted_at.beginning_of_month
    end_date = start_date + 1.month
    self.class.readonly.where( posted_at: start_date..end_date )
  end

  # Class methods

  def self.find_post( year, month, slug )
    posts_for_month( year, month ).find_by( slug: slug )
  end

  def self.posts_for_year( year )
    start_date = Date.new( year.to_i, 1, 1 )
    end_date = start_date + 1.year
    where( posted_at: start_date..end_date ).order( :posted_at ).readonly
  end

  def self.posts_for_month( year, month )
    start_date = Date.new( year.to_i, month.to_i, 1 )
    end_date = start_date + 1.month
    where( posted_at: start_date..end_date ).order( :posted_at ).readonly
  end

  def self.recent_posts( page_num = 1 )
    where( hidden: false ).order( posted_at: :desc ).readonly.page( page_num )
  end
end
