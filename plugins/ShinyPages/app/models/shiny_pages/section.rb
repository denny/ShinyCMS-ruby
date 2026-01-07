# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Model for page sections - part of the ShinyPages plugin for ShinyCMS
  class Section < ApplicationRecord
    include ShinyCMS::CanHide
    include ShinyCMS::HasPublicName
    include ShinyCMS::HasReadableName
    include ShinyCMS::HasSlugUniqueInSection
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    include ShinyCMS::WithSettings

    include ShinyPages::TopLevelSlugValidator

    # Associations

    belongs_to :section, inverse_of: :all_sections, optional: true, class_name: 'Section'

    has_many :all_pages,    inverse_of: :section, dependent: :restrict_with_error, class_name: 'Page'
    has_many :all_sections, inverse_of: :section, dependent: :restrict_with_error, class_name: 'Section'

    # Validations

    validates :slug, unique_top_level_slug: true, if: -> { section.blank? }

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

    def pages
      all_pages.visible
    end

    def sections
      all_sections.visible
    end

    def menu_pages
      pages.visible_in_menus
    end

    def menu_sections
      sections.visible_in_menus
    end

    # Return the default page for this section if one is set
    # If the default isn't set, return the first page in this section
    def default_page
      return pages.with_elements.find self[ :default_page_id ] if self[ :default_page_id ]

      pages.with_elements.min
    end

    def all_page_items
      pages = all_pages.to_a
      sections = all_sections.to_a

      [ *pages, *sections ].sort_by do |item|
        [ item.position ? 0 : 1, item.position || 0 ]
      end
    end

    def menu_items
      pages = menu_pages.to_a
      sections = menu_sections.to_a

      [ *pages, *sections ].sort_by do |item|
        [ item.position ? 0 : 1, item.position || 0 ]
      end
    end

    def submenu?
      menu_pages.present? || menu_sections.present?
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

    # Return the default top-level section
    def self.default_section
      name_or_slug = setting( :default_section )
      top_level_sections.where( internal_name: name_or_slug )
                        .or( top_level_sections
                        .where( slug: name_or_slug ) )
                        .first
    end
  end
end
