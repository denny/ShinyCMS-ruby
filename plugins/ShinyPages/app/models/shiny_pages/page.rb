# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Model for 'brochure' pages
  class Page < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyName
    include ShinyShowHide
    include ShinySlugInSection
    include ShinyWithTemplate

    # Associations

    belongs_to :section,  inverse_of: :all_pages, optional: true
    belongs_to :template, inverse_of: :pages
    has_many   :elements, -> { order( :id ) },  inverse_of: :page,
                                                foreign_key: :page_id,
                                                class_name: 'PageElement',
                                                dependent: :destroy

    accepts_nested_attributes_for :elements

    # Validations

    validates :slug, safe_top_level_slug: true, if: -> { section.blank? }

    # Scopes and default sort order

    scope :top_level, -> { where( section: nil ) }

    self.implicit_order_column = 'sort_order'

    # Instance methods

    def default_page?
      self == ShinyPages::Page.default_page
    end

    # Class methods

    def self.policy_class
      PagePolicy
    end

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
      sections = Section.all_top_level_sections.to_a

      [ *pages, *sections ].sort_by do |item|
        [ item.sort_order ? 0 : 1, item.sort_order || 0 ]
      end
    end

    def self.top_level_menu_items
      pages = top_level_menu_pages.to_a
      sections = Section.top_level_menu_sections.to_a

      [ *pages, *sections ].sort_by do |item|
        [ item.sort_order ? 0 : 1, item.sort_order || 0 ]
      end
    end

    # Return the configured default page, or one of a few fallback options, or nil
    def self.default_page
      configured_default_page || Section.default_section&.default_page || top_level_pages.min
    end

    def self.configured_default_page
      name_or_slug = Setting.get :default_page
      top_level_pages
        .where( internal_name: name_or_slug )
        .or( top_level_pages
        .where( slug: name_or_slug ) )
        .first
    end
  end
end
