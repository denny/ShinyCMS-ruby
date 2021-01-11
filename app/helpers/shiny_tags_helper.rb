# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Helper methods for displaying tag details (that filter out tags on hidden content)
module ShinyTagsHelper
  include ActsAsTaggableOn::TagsHelper

  def taggings_count( tag )
    tag = tag_object( tag ) if tag.is_a? String
    tag.taggings.where( context: 'tags' ).count
  end

  def tag_object( tag_name )
    ActsAsTaggableOn::Tag.find_by( name: tag_name )
  end
end
