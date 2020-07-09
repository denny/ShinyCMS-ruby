# frozen_string_literal: true

# Model class for news posts
class NewsPost < ApplicationRecord
  include PostedAt
  include SlugInMonth
  include Teaser

  # Associations

  belongs_to :user, inverse_of: :news_posts

  has_one :discussion, as: :resource, dependent: :destroy

  # Validations

  validates :body,    presence: true
  validates :title,   presence: true
  validates :user_id, presence: true

  # Plugin features

  acts_as_taggable
  acts_as_votable
  paginates_per 20

  # Attribute aliases and delegated methods

  alias_attribute :author, :user

  delegate :hidden, to: :discussion, allow_nil: true, prefix: true
  delegate :locked, to: :discussion, allow_nil: true, prefix: true

  # Instance methods

  def path( anchor: nil )
    url_helpers.view_news_post_path(
      posted_year, posted_month, slug, anchor: anchor
    )
  end

  # Class methods

  def self.find_post( year, month, slug )
    posts_for_month( year, month ).find_by( slug: slug )
  end

  def self.recent_posts( page_num = 1 )
    where( hidden: false ).order( posted_at: :desc ).readonly.page( page_num )
  end
end
