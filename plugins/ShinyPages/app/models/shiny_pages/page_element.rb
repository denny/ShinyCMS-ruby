# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Model class for page elements - part of the ShinyPages plugin for ShinyCMS
  class PageElement < ApplicationRecord
    include ShinySearch::Searchable if ::Plugin.loaded? :ShinySearch
    include ShinyDemoDataProvider
    include ShinyElement

    belongs_to :page, inverse_of: :elements

    validates :page, presence: true

    acts_as_list scope: :page

    searchable_by :content if ::Plugin.loaded? :ShinySearch # TODO

    def hidden?
      false
    end
  end
end
