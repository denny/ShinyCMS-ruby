# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Wrapper around acts-as-taggable-on; hides tags that are on hidden content
module ShinyTags
  extend ActiveSupport::Concern

  included do
    # Set up two tag contexts - main and hidden

    acts_as_taggable_on :tags, :hidden_tags

    # Callbacks

    # rubocop:disable Style/RedundantSelf
    before_commit :show_tags, if: -> { !self.hidden? && self.hidden_tag_list.present? }
    before_commit :hide_tags, if: -> { self.hidden?  && self.tag_list.present?        }
    # rubocop:enable Style/RedundantSelf

    # Instance methods

    def show_tags
      self.tag_list = hidden_tag_list
      self.hidden_tag_list = nil
    end

    def hide_tags
      self.hidden_tag_list = tag_list
      self.tag_list = nil
    end
  end
end
