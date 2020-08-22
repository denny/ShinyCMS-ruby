# frozen_string_literal: true

module ShinyPages
  # Model for page sections
  class Section < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyName
    include ShinySlugInSection
    include ShinyShowHide

    # Associations

    belongs_to :section, class_name: 'ShinyPages::Section', inverse_of: :all_sections, optional: true

    has_many :all_pages, class_name: 'ShinyPages::Page', inverse_of: :section, dependent: :restrict_with_error

    has_many :all_sections, class_name: 'ShinyPages::Section', inverse_of: :section, dependent: :restrict_with_error

    # Validations

    validates :slug, safe_top_level_slug: true, if: -> { section.blank? }

    # Scopes and default sort order

    scope :top_level, -> { where( section: nil  ) }

    self.implicit_order_column = 'sort_order'

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
      return pages.find self[ :default_page_id ] if self[ :default_page_id ]

      pages.min
    end

    def all_page_items
      pages = all_pages.to_a
      sections = all_sections.to_a

      [ *pages, *sections ].sort_by do |item|
        [ item.sort_order ? 0 : 1, item.sort_order || 0 ]
      end
    end

    def menu_items
      pages = menu_pages.to_a
      sections = menu_sections.to_a

      [ *pages, *sections ].sort_by do |item|
        [ item.sort_order ? 0 : 1, item.sort_order || 0 ]
      end
    end

    def submenu?
      menu_pages.present? || menu_sections.present?
    end

    # Specify policy class for Pundit
    def policy_class
      self.class.policy_class
    end

    # Class methods

    def self.policy_class
      ShinyPages::SectionPolicy
    end

    def self.all_top_level_sections
      ShinyPages::Section.top_level
    end

    def self.top_level_sections
      ShinyPages::Section.top_level.visible
    end

    def self.top_level_menu_sections
      ShinyPages::Section.top_level.visible_in_menus
    end

    # Return the default top-level section
    def self.default_section
      name_or_slug = Setting.get :default_section
      top_level_sections.where( internal_name: name_or_slug )
                        .or( top_level_sections
                        .where( slug: name_or_slug ) )
                        .first
    end
  end
end
