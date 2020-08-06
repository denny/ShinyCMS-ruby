# frozen_string_literal: true

# Model class for news posts
class NewsPost < ApplicationRecord
  include ShinyPost

  # Associations

  belongs_to :user, inverse_of: :news_posts

  has_one :discussion, as: :resource, dependent: :destroy

  # Instance methods

  def path( anchor: nil )
    url_helpers.view_news_post_path(
      posted_year, posted_month, slug, anchor: anchor
    )
  end

  # Class methods

  def self.dump_for_demo?
    true
  end
end
