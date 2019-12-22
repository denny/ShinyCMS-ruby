# Model class for blog posts
class BlogPost < ApplicationRecord
  belongs_to :user
  belongs_to :blog

  delegate :month, to: :posted_at
  delegate :year,  to: :posted_at

  # Instance methods

  def view_path
    if Blog.multiple_blogs_mode
      # :nocov:
      "/blog/#{blog.slug}/#{year}/#{month}/#{slug}"
      # :nocov:
    else
      "/blog/#{year}/#{month}/#{slug}"
    end
  end
end
