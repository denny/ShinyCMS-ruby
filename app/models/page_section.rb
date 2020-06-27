# frozen_string_literal: true

# Model for page sections
class PageSection < ApplicationRecord
  include NameAndTitle
  include SlugInSection

  # Associations

  belongs_to :section,    class_name: 'PageSection',
                          inverse_of: 'all_sections',
                          optional: true

  has_many :all_pages,    class_name: 'Page',
                          foreign_key: 'section_id',
                          inverse_of: 'section',
                          dependent: :restrict_with_error

  has_many :all_sections, class_name: 'PageSection',
                          foreign_key: 'section_id',
                          inverse_of: 'section',
                          dependent: :restrict_with_error

  # Validations

  validates :hidden, inclusion: { in: [ true, false ] }
  validates :slug, safe_top_level_slug: true, if: -> { section.blank? }

  # Scopes

  default_scope { order( :sort_order ) }

  scope :top_level,        -> { where( section_id: nil ) }
  scope :visible,          -> { where( hidden: false ) }
  scope :visible_in_menus, -> { where( hidden: false, hidden_from_menu: false ) }

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

  # Class methods

  def self.all_top_level_sections
    PageSection.top_level
  end

  def self.top_level_sections
    PageSection.top_level.visible
  end

  def self.top_level_menu_sections
    PageSection.top_level.visible_in_menus
  end

  # Return the default top-level section
  def self.default_section
    name_or_slug = Setting.get :default_section
    top_level_sections.where( name: name_or_slug )
                      .or( top_level_sections
                      .where( slug: name_or_slug ) )
                      .first
  end
end
