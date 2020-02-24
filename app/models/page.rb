# Model for 'brochure' pages
class Page < ApplicationRecord
  include NameTitleSlug

  validates :template_id, presence:  true
  validates :hidden,      inclusion:  { in: [ true, false ] }

  belongs_to :section,  class_name: 'PageSection', optional: true,
                        inverse_of: 'all_pages'

  belongs_to :template, class_name: 'PageTemplate',
                        inverse_of: 'pages'

  has_many :elements, -> { order( id: :asc ) },
           class_name: 'PageElement',
           foreign_key: 'page_id',
           inverse_of: 'page',
           dependent: :destroy

  accepts_nested_attributes_for :elements

  after_create :add_elements

  default_scope { order( :sort_order ) }

  # Instance methods

  # Add the elements specified by the template
  def add_elements
    template.elements.each do |template_element|
      elements.create!(
        name: template_element.name,
        content: template_element.content,
        content_type: template_element.content_type
      )
    end
  end

  # Returns a hash of all the elements for this page, to feed to render's local
  def elements_hash
    hash = {}
    elements.each do |element|
      hash[ element.name.to_sym ] = element.content
    end
    hash
  end

  # Return true if this page is the default page
  def default_page?
    self == Page.default_page
  end

  # Class methods

  def self.all_top_level_pages
    Page.where( section: nil )
  end

  def self.top_level_pages
    Page.all_top_level_pages.where( hidden: false )
  end

  def self.top_level_menu_pages
    Page.top_level_pages.where( hidden_from_menu: false )
  end

  def self.top_level_menu_items
    pages = Page.top_level_menu_pages.to_a
    sections = PageSection.top_level_menu_sections.to_a

    [ *pages, *sections ].sort_by do |item|
      [ item.sort_order ? 0 : 1, item.sort_order || 0 ]
    end
  end

  def self.all_top_level_items
    pages = Page.all_top_level_pages.to_a
    sections = PageSection.all_top_level_sections.to_a

    [ *pages, *sections ].sort_by do |item|
      [ item.sort_order ? 0 : 1, item.sort_order || 0 ]
    end
  end

  # Return the configured default page, or one of a few fallback options, or nil
  def self.default_page
    name_or_slug = Setting.get :default_page
    top_level_pages
      .where( name: name_or_slug )
      .or( top_level_pages
      .where( slug: name_or_slug ) )
      .first ||

      PageSection.default_section&.default_page ||

      Page.top_level_pages.min
  end
end
