# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Model class for page elements - part of the ShinyPages plugin for ShinyCMS
  class PageElement < ApplicationRecord
    include ShinyCMS::Element

    include ShinyCMS::ProvidesDemoSiteData

    belongs_to :page, inverse_of: :elements

    acts_as_list scope: :page

    if ShinyCMS.plugins.loaded? :ShinySearch
      include ShinySearch::Searchable

      searchable_by :content  # TODO
    end

    validates :page, presence: true

    delegate :hidden?, to: :page
  end
end
