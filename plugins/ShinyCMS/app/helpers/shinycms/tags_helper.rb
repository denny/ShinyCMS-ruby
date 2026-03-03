# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for displaying tag details (that filter out tags on hidden content)
  module TagsHelper
    include ActsAsTaggableOn::TagsHelper

    def taggings_count( tag )
      tag.taggings.where( context: 'tags' ).count
    end
  end
end
