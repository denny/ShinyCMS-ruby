# frozen_string_literal: true

# Validator for slugs that only need to be unique within the month they are posted
# e.g. blog posts, news posts, etc
module ShinySlugInMonth
  extend ActiveSupport::Concern

  include ShinySlug

  included do
    validates :slug, unique_in_collection: {
      collection: ->( record ) { record.posts_in_same_month },
      message: I18n.t( 'errors.messages.slug_not_unique_in_month' )
    }
  end
end
