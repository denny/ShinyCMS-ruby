# frozen_string_literal: true

# Model class for blog posts
class BlogPost < ApplicationRecord
  include SlugInMonth
  include Teaser

  belongs_to :blog
  belongs_to :user, inverse_of: :blog_posts

  alias_attribute :author, :user

  has_one :discussion, as: :resource, dependent: :destroy

  delegate :hidden, to: :discussion, allow_nil: true, prefix: true
  delegate :locked, to: :discussion, allow_nil: true, prefix: true

  validates :blog_id, presence: true
  validates :user_id, presence: true
  validates :title,   presence: true
  validates :body,    presence: true

  # Configure default count-per-page for pagination
  paginates_per 20

  # Add tagging features
  acts_as_taggable

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

  def teaser( paragraphs: 3 )
    paras = body.split %r{</p>[^<]*<p>}i
    return paras[ 0..( paragraphs - 1 ) ].join( "</p>\n<p>" ) if paras.size > 1

    paras = body.split %r{<br ?/?><br ?/?>}i
    return paras[ 0..( paragraphs - 1 ) ].join "\n<br><br>\n" if paras.size > 1

    body
  end
end
