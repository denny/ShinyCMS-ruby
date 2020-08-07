# frozen_string_literal: true

module ShinyNews
  # Model for ShinyCMS news posts
  class Post < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyPost

    # Associations

    # TODO: this needs to be polymorphic I think?
    belongs_to :user, inverse_of: :shiny_news_posts

    has_one :discussion, as: :resource, dependent: :destroy

    # Instance methods

    def path( anchor: nil )
      url_helpers.view_news_post_path(
        posted_year, posted_month, slug, anchor: anchor
      )
    end
  end
end
