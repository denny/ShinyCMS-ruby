# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Wrapper around ActsAsVotableOn
  module ShinyWithVotes
    extend ActiveSupport::Concern

    included do
      acts_as_votable

      # Instance methods

      def vote_url_class_name
        self.class.name.underscore.parameterize
      end
    end
  end
end
