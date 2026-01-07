# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Model for 'brochure' pages - part of the ShinyPages plugin for ShinyCMS
  class Page < ApplicationRecord
    include ShinyCMS::CanHide
    include ShinyCMS::HasPublicName
    include ShinyCMS::HasReadableName
    include ShinyCMS::HasSlugUniqueInSection
    include ShinyCMS::HasTemplate
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData
    include ShinyCMS::ProvidesSitemapData

    include ShinyCMS::WithSettings

    include ShinyPages::TopLevelSlugValidator

    # Associations

    belongs_to :section,  inverse_of: :all_pages, optional: true
    belongs_to :template, inverse_of: :pages

    has_many :elements, -> { order( :position ).includes( [ :image_attachment ] ) },
             inverse_of: :page, dependent: :destroy, class_name: 'PageElement'

    accepts_nested_attributes_for :elements, allow_destroy: true

    # Validations

    validates :slug, unique_top_level_slug: true, if: -> { section.blank? }

    # Plugin features

    if ShinyCMS.plugins.loaded? :ShinySearch
      include ShinySearch::Searchable

      searchable_by :public_name, :slug  # TODO: elements!
    end

    # Scopes and sorting

    scope :top_level, -> { where( section: nil ) }

    acts_as_list scope: :section
    self.implicit_order_column = 'position'

    # Instance methods

    def default_page?
      self == Page.default_page
    end

    def path
      full_path = slug

      parent = section
      while parent.present?
        full_path = "#{parent.slug}/#{full_path}"
        parent = parent.section
      end

      "/#{full_path}"
    end

    # Class methods

    def self.all_top_level_pages
      top_level
    end

    def self.top_level_pages
      top_level.visible
    end

    def self.top_level_menu_pages
      top_level.visible_in_menus
    end

    def self.all_top_level_items
      pages = all_top_level_pages.to_a
      sections = Section.includes( %i[ all_pages all_sections ] ).all_top_level_sections.to_a

      [ *pages, *sections ].sort_by do |item|
        [ item.position ? 0 : 1, item.position || 0 ]
      end
    end

    def self.top_level_menu_items
      pages = top_level_menu_pages.to_a
      sections = Section.top_level_menu_sections.to_a

      [ *pages, *sections ].sort_by do |item|
        [ item.position ? 0 : 1, item.position || 0 ]
      end
    end

    # Return the configured default page, or one of a few fallback options, or nil
    def self.default_page
      configured_default_page || Section.default_section&.default_page || top_level_pages.min
    end

    def self.configured_default_page
      name_or_slug = setting( :default_page )
      top_level_pages
        .where( internal_name: name_or_slug )
        .or( top_level_pages
        .where( slug: name_or_slug ) )
        .first
    end

    def self.sitemap_items
      # Excludes the default page because the sitemap_generator gem includes root_path by default
      visible.readonly.where.not id: default_page.id
      # TODO: make this put top-level pages first and then work it's way down
      # a layer at a time - as a generic approximation of 'page importance'.
    end
  end
end
