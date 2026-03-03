# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # For resources that want to allow upvotes/downvotes via ActsAsVotable
  module HasVotes
    extend ActiveSupport::Concern

    included do
      acts_as_votable
    end

    class_methods do
      # Turn the class name into a URL-safe string
      # e.g. ShinyBlog::Post -> shiny_blog-post
      # This is reversed in the ShinyCMS::Votes controller concern
      def name_to_url_param
        name.underscore.parameterize
      end
    end
  end
end
