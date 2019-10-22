# Model for 'brochure' pages
class Page < ApplicationRecord
  validates :name,        presence:  true
  validates :title,       presence:  true
  validates :slug,        presence:  true
  validates :template_id, presence:  true
  validates :slug,        safe_slug: true
  validates :hidden,      inclusion:  { in: [ true, false ] }
  validates :slug,        uniqueness: {
    scope: :section,
    message: I18n.t( 'slug_unique' )
  }

  belongs_to :section,  class_name: 'PageSection', optional: true,
                        inverse_of: 'pages'
  belongs_to :template, class_name: 'PageTemplate',
                        inverse_of: 'pages'

  has_many :elements, class_name: 'PageElement',
                      foreign_key: 'page_id',
                      inverse_of: 'page',
                      dependent: :delete_all

  accepts_nested_attributes_for :elements

  after_create :add_elements

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

  # Class methods

  def self.top_level_pages
    Page.where( section: nil, hidden: false )
  end

  def self.top_level_hidden_pages
    Page.where( section: nil, hidden: true )
  end

  def self.are_there_any_hidden_pages?
    Page.exists?( hidden: true )
  end

  # Return the default top-level page
  def self.default_page
    page = find_default_page
    return page if page

    section = PageSection.default_section
    page    = section&.pages&.default_page
    page  ||= section&.pages&.first
    return page if page

    return Page.top_level_pages.first if Page.top_level_pages.first

    Page.order( :created_at ).find_by( hidden: false )
  end

  # Return the default top-level page
  def self.find_default_page
    name_or_slug = Setting.get I18n.t( 'default_page' )
    top_level_pages.where( name: name_or_slug )
                   .or( top_level_pages
                   .where( slug: name_or_slug ) )
                   .first
  end
end
