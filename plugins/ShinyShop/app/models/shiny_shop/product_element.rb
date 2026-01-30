# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Model class for product elements - part of the ShinyShop plugin for ShinyCMS
  class ProductElement < ApplicationRecord
    include ShinyCMS::Element

    include ShinyCMS::ProvidesDemoSiteData

    belongs_to :product, inverse_of: :elements

    acts_as_list scope: :product

    if ShinyCMS.plugins.loaded? :ShinySearch
      include ShinySearch::Searchable

      searchable_by :content  # TODO
    end

    validates :product, presence: true

    delegate :hidden?, to: :product
  end
end
