# frozen_string_literal: true

# Slugs that only have to be unique within a section (e.g. page.slug)
module SlugInSection
  extend ActiveSupport::Concern
  include Slug

  included do
    validates :slug, uniqueness: {
      scope: :section,
      case_sensitive: false,
      message: I18n.t( 'errors.messages.slug_in_section' )
    }
  end
end
