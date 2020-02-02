# Model for page sections
class PageSection < ApplicationRecord
  include NameTitleSlug

  validates :hidden, inclusion:  { in: [ true, false ] }

  has_many  :pages,
            -> { where( hidden: false ).order( :sort_order ) },
            foreign_key: 'section_id',
            inverse_of: 'section',
            dependent: :restrict_with_error

  has_many  :hidden_pages,
            -> { where( hidden: true ).order( :sort_order ) },
            class_name: 'Page',
            foreign_key: 'section_id',
            inverse_of: 'section',
            dependent: :restrict_with_error

  has_many  :all_pages,
            -> { order( :sort_order ) },
            class_name: 'Page',
            foreign_key: 'section_id',
            inverse_of: 'section',
            dependent: :restrict_with_error

  has_many  :sections,
            -> { where( hidden: false ).order( :sort_order ) },
            class_name: 'PageSection',
            foreign_key: 'section_id',
            inverse_of: 'section',
            dependent: :restrict_with_error

  has_many  :hidden_sections,
            -> { where( hidden: true ).order( :sort_order ) },
            class_name: 'PageSection',
            foreign_key: 'section_id',
            inverse_of: 'section',
            dependent: :restrict_with_error

  has_many  :all_sections,
            -> { order( :sort_order ) },
            class_name: 'PageSection',
            foreign_key: 'section_id',
            inverse_of: 'section',
            dependent: :restrict_with_error

  belongs_to  :section,
              class_name: 'PageSection',
              inverse_of: 'sections',
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

  def menu_pages
    pages.where( hidden_from_menu: false )
  end

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
    PageSection.where( section: nil ).order( :sort_order )
  end

  def self.top_level_sections
    PageSection.where( section: nil, hidden: false ).order( :sort_order )
  end

  def self.top_level_hidden_sections
    PageSection.where( section: nil, hidden: true ).order( :sort_order )
  end

  def self.top_level_menu_sections
    PageSection.top_level_sections.where( hidden_from_menu: false )
               .order( :sort_order )
  end

  # Return the default top-level section
  def self.default_section
    name_or_slug = Setting.get I18n.t( 'admin.settings.default_section' )
    top_level_sections.where( name: name_or_slug )
                      .or( top_level_sections
                      .where( slug: name_or_slug ) )
                      .first
  end
end
