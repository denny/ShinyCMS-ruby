# frozen_string_literal: true

# Model class for blogs (which are a collection of blog posts)
class Blog < ApplicationRecord
  include ShinyDemoDataProvider
  include ShinyName
  include ShinyShowHide
  include ShinySlug

  # Associations

  belongs_to :user, inverse_of: :blogs

  has_many :all_posts, inverse_of: :blog, class_name: 'BlogPost', dependent: :restrict_with_error

  # Plugins

  paginates_per 20

  # Aliases

  alias_attribute :owner, :user

  # Instance methods

  def posts
    all_posts.readonly.published
  end

  def posts_for_month( year, month )
    start_date = Date.new( year.to_i, month.to_i, 1 )
    end_date = start_date + 1.month
    posts.where( posted_at: start_date..end_date ).order( :posted_at )
  end

  def posts_for_year( year_string )
    year = Date.new( year_string.to_i, 1, 1 )
    posts.where( posted_at: year..year.end_of_year ).order( :posted_at )
  end

  def find_post( year, month, slug )
    posts_for_month( year, month ).find_by( slug: slug )
  end

  def recent_posts( page_num = 1 )
    posts.order( posted_at: :desc ).page( page_num )
  end

  # Class methods

  def self.multiple_blogs_mode?
    Rails.application.config.multiple_blogs_mode == true
  end
end
