# Model for page sections
class PageSection < ApplicationRecord
  include NameTitleSlug

  validates :hidden, inclusion:  { in: [ true, false ] }

  default_scope { order( :sort_order ) }

  has_many  :all_pages,
            class_name: 'Page',
            foreign_key: 'section_id',
            inverse_of: 'section',
            dependent: :restrict_with_error

  has_many  :all_sections,
            class_name: 'PageSection',
            foreign_key: 'section_id',
            inverse_of: 'section',
            dependent: :restrict_with_error

  belongs_to  :section,
              class_name: 'PageSection',
              inverse_of: 'all_sections',
              optional: true

  # Instance methods

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

  def pages
    all_pages.where( hidden: false )
  end

  # def hidden_pages
  #  all_pages.where( hidden: true )
  # end

  def menu_pages
    pages.where( hidden_from_menu: false )
  end

  def sections
    all_sections.where( hidden: false )
  end

  # def hidden_sections
  #  all_sections.where( hidden: true )
  # end

  def menu_sections
    sections.where( hidden_from_menu: false )
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
    PageSection.where( section: nil )
  end

  def self.top_level_sections
    PageSection.all_top_level_sections.where( hidden: false )
  end

  def self.top_level_menu_sections
    PageSection.top_level_sections.where( hidden_from_menu: false )
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
