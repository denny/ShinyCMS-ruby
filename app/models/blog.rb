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
    posts.order( posted_at: :desc ).reverse
  end

  def find_post( year, month, slug )
    unless year.match( %r{^\d\d\d\d$} ) && month.match( %r{^\d\d$} )
      raise ShinyCMSError, 'Bad date range'
    end

    start_date = "#{year}-#{month}-01".to_date
    end_date = start_date.clone + 1.month
    posts.find_by(
      "created_at between '#{start_date}' and '#{end_date}'",
      slug: slug
    )
  end

  # Class methods

  def self.multiple_blogs_mode
    Rails.application.config.multiple_blogs_mode == true
  end
end
