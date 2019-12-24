# Model class for blogs (which are a collection of blog posts)
class Blog < ApplicationRecord
  belongs_to :user

  has_many :all_posts,
           class_name: 'BlogPost',
           foreign_key: 'blog_id',
           inverse_of: 'blog',
           dependent: :restrict_with_error

  # Configure default count-per-page for pagination
  paginates_per 20

  # Instance methods

  def posts
    all_posts.where( hidden: false )
  end

  def hidden_posts
    all_posts.where( hidden: true )
  end

  def recent_posts
    posts.order( posted_at: :desc )
  end

  def find_post( year, month, slug )
    start_date = "#{year}-#{month}-01".to_date
    end_date = start_date.clone + 1.month
    posts.find_by(
      'created_at between ? and ? and slug = ?',
      start_date.to_s,
      end_date.to_s,
      slug
    )
  end

  # Class methods

  def self.multiple_blogs_mode
    Rails.application.config.multiple_blogs_mode == true
  end
end
