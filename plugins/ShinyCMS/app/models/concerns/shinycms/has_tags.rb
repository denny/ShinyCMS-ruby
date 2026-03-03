# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Wrapper around ActsAsTaggableOn
  # Keeps show/hide status of tags in sync with show/hide status of tagged resource
  module HasTags
    extend ActiveSupport::Concern

    included do
      # Create two contexts; one for normal tags, one to stash hidden tags in

      acts_as_ordered_taggable_on :tags, :hidden_tags

      # Adjust show/hide context for tags based on resource show/hide status

      before_commit :show_tags, if: -> { visible? && hidden_tag_list.present? }
      before_commit :hide_tags, if: -> { hidden?  && tag_list.present?        }

      # Instance methods

      def show_tags
        self.tag_list = hidden_tag_list
        self.hidden_tag_list = nil
        save!
      end

      def hide_tags
        self.hidden_tag_list = tag_list
        self.tag_list = nil
        save!
      end
    end
  end
end
