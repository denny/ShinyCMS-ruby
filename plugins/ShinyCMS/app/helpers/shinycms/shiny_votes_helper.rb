# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper method for turning a ShinyWithVotes URL param back into a class name
  module ShinyVotesHelper
    include ActsAsTaggableOn::TagsHelper

    def class_from_votable_url( url_param )
      url_param.tr( '-', '/' ).classify
    end
  end
end