# frozen_string_literal: true

# Model class for blog posts
class BlogPost < ApplicationRecord
  include PostedAt
  include SlugInMonth
  include Teaser

  # Associations

  belongs_to :blog
  belongs_to :user, inverse_of: :blog_posts

  has_one :discussion, as: :resource, dependent: :destroy

  # Validations

  validates :blog_id, presence: true
  validates :body,    presence: true
  validates :title,   presence: true
  validates :user_id, presence: true

  # Plugins

  acts_as_taggable
  paginates_per 20

  # Aliases and delegated methods

  alias_attribute :author, :user

  delegate :hidden, to: :discussion, allow_nil: true, prefix: true
  delegate :locked, to: :discussion, allow_nil: true, prefix: true

  # Scopes

  scope :visible, -> { where( hidden: false ) }
  scope :published, -> { visible.merge( not_future_dated ) }

  # Instance methods

  def path( anchor: nil )
    if Blog.multiple_blogs_mode?
      # :nocov:
      url_helpers.view_blog_post_path(
        blog.slug, posted_year, posted_month, slug, anchor: anchor
      )
      # :nocov:
    else
      url_helpers.view_blog_post_path(
        posted_year, posted_month, slug, anchor: anchor
      )
    end
  end
end
