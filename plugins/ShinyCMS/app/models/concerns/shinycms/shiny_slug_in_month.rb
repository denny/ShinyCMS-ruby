# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Validator for slugs that only need to be unique within a given month (e.g. blog posts, news posts, etc)
  module ShinySlugInMonth
    extend ActiveSupport::Concern

    include ShinySlug

    included do
      validates :slug, unique_in_collection: {
        collection: ->( record ) { record.items_in_same_month },
        message:    I18n.t( 'errors.messages.slug_not_unique_in_month' )
      }
    end
  end
end
