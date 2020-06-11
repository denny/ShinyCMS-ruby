# frozen_string_literal: true

# Slugs that only have to be unique within a month (e.g. blog_post, news_post)
module SlugInMonth
  extend ActiveSupport::Concern
  include Slug

  included do
    validates :slug, uniqueness: {
      conditions: -> { where( posted_at: :posted_at ) },
      case_sensitive: false,
      message: I18n.t( 'errors.messages.slug_in_month' )
    }
  end
end
