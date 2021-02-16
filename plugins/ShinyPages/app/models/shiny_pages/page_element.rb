# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Model class for page elements - part of the ShinyPages plugin for ShinyCMS
  class PageElement < ApplicationRecord
    include ShinyCMS::ShinyDemoDataProvider
    include ShinyCMS::ShinyElement

    include ShinySearch::Searchable if ShinyCMS::ShinyPlugin.loaded? :ShinySearch

    # Assocations

    belongs_to :page, inverse_of: :elements

    # Plugin features

    acts_as_list scope: :page

    searchable_by :content if ShinyCMS::ShinyPlugin.loaded? :ShinySearch # TODO

    # Validations

    validates :page, presence: true

    # Instance methods

    def hidden?
      false
    end
  end
end
