# frozen_string_literal: true

# Validator for slugs that only need to be unique within a section
# e.g. page.slug / page_section.slug / shop_item.slug / etc
module ShinySlugInSection
  extend ActiveSupport::Concern
  include ShinySlug

  included do
    validates :slug, uniqueness: {
      scope: :section,
      message: I18n.t( 'errors.messages.slug_not_unique_in_section' )
    }
  end
end
