# frozen_string_literal: true

module ShinyBlogs
  # Model class for blog posts
  class BlogPost < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyPost

    # Associations

    belongs_to :blog, class_name: 'ShinyBlogs::Blog'
    belongs_to :user, inverse_of: :shiny_blogs_blog_posts

    has_one :discussion, as: :resource, dependent: :destroy

    # Validations

    validates :blog_id, presence: true

    # Instance methods

    def path( anchor: nil )
      url_helpers.view_blog_post_path(
        blog.slug, posted_year, posted_month, slug, anchor: anchor
      )
    end

    # Specify policy class for Pundit
    def policy_class
      Admin::BlogPostPolicy
    end

    # Class methods

    def self.human_name
      'blog post'
    end

    def self.policy_class
      Admin::BlogPostPolicy
    end
  end
end

# Add inverse association for authors of blog posts
::User.has_many :shiny_blogs_blog_posts, dependent: :restrict_with_error, class_name: 'ShinyBlogs::BlogPost'
