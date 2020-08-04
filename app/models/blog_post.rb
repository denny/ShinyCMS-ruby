# frozen_string_literal: true

# Model class for blog posts
class BlogPost < ApplicationRecord
  include ShinyPost

  # Associations

  belongs_to :blog
  belongs_to :user, inverse_of: :blog_posts

  # Validations

  validates :blog_id, presence: true

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
