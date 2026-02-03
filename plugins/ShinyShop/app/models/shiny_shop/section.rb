# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Model for shop sections - part of the ShinyShop plugin for ShinyCMS
  class Section < ApplicationRecord
    include ShinyCMS::CanHide
    include ShinyCMS::HasPublicName
    include ShinyCMS::HasReadableName
    include ShinyCMS::HasSlugUniqueInSection
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    include ShinyCMS::WithSettings

    # Associations

    belongs_to :section, inverse_of: :all_sections, optional: true, class_name: 'Section'

    has_many :all_products, inverse_of: :section, dependent: :restrict_with_error, class_name: 'Product'
    has_many :all_sections, inverse_of: :section, dependent: :restrict_with_error, class_name: 'Section'

    # Plugin features

    if ShinyCMS.plugins.loaded? :ShinySearch
      include ShinySearch::Searchable

      searchable_by :public_name, :slug
    end

    # Scopes and sorting

    scope :top_level, -> { where( section: nil  ) }

    acts_as_list scope: :section
    self.implicit_order_column = 'position'

    # Instance methods

    def products
      all_products.visible
    end

    def sections
      all_sections.visible
    end

    def menu_products
      products.visible_in_menus
    end

    def menu_sections
      sections.visible_in_menus
    end

    def slugs
      return [ slug ] if section.nil?

      section.slugs + [ slug ]
    end

    def all_product_items
      products = all_products.to_a
      sections = all_sections.to_a

      [ *products, *sections ].sort_by do |item|
        [ item.position ? 0 : 1, item.position || 0 ]
      end
    end

    def menu_items
      products = menu_products.to_a
      sections = menu_sections.to_a

      [ *products, *sections ].sort_by do |item|
        [ item.position ? 0 : 1, item.position || 0 ]
      end
    end

    def submenu?
      menu_products.present? || menu_sections.present?
    end

    # Class methods

    def self.all_top_level_sections
      top_level
    end

    def self.top_level_sections
      top_level.visible
    end

    def self.top_level_menu_sections
      top_level.visible_in_menus
    end
  end
end
