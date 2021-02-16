# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Validator for slugs that only need to be unique within a section (e.g. page.slug / page_section.slug / etc)
  module ShinySlugInSection
    extend ActiveSupport::Concern

    include ShinySlug

    included do
      validates :slug, uniqueness: {
        scope:   :section,
        message: I18n.t( 'shinycms.errors.messages.slug_not_unique_in_section' )
      }
    end
  end
end
