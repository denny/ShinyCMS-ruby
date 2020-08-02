# frozen_string_literal: true

# Model for 'brochure' pages
class Page < ApplicationRecord
  include ShinyName
  include ShinySlugInSection

  # Associations

  belongs_to :section,  inverse_of: :all_pages, class_name: 'PageSection', optional: true
  belongs_to :template, inverse_of: :pages,     class_name: 'PageTemplate'

  has_many :elements, -> { order( :id ) },  inverse_of: :page,
                                            foreign_key: :page_id,
                                            class_name: 'PageElement',
                                            dependent: :destroy

  accepts_nested_attributes_for :elements

  # Validations

  validates :hidden,      inclusion: { in: [ true, false ] }
  validates :slug,        safe_top_level_slug: true, if: -> { section.blank? }
  validates :template_id, presence: true

  # Before/after actions

  after_create :add_elements

  # Scopes and default sort order

  scope :top_level,        -> { where( section: nil ) }
  scope :visible,          -> { where( hidden: false ) }
  scope :visible_in_menus, -> { where( hidden: false, hidden_from_menu: false ) }

  self.implicit_order_column = 'sort_order'

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

  def default_page?
    self == Page.default_page
  end

  # Class methods

  def self.all_top_level_pages
    Page.top_level
  end

  def self.top_level_pages
    Page.top_level.visible
  end

  def self.top_level_menu_pages
    Page.top_level.visible_in_menus
  end

  def self.all_top_level_items
    pages = Page.all_top_level_pages.to_a
    sections = PageSection.all_top_level_sections.to_a

    [ *pages, *sections ].sort_by do |item|
      [ item.sort_order ? 0 : 1, item.sort_order || 0 ]
    end
  end

  def self.top_level_menu_items
    pages = Page.top_level_menu_pages.to_a
    sections = PageSection.top_level_menu_sections.to_a

    [ *pages, *sections ].sort_by do |item|
      [ item.sort_order ? 0 : 1, item.sort_order || 0 ]
    end
  end

  # Return the configured default page, or one of a few fallback options, or nil
  def self.default_page
    name_or_slug = Setting.get :default_page
    top_level_pages
      .where( internal_name: name_or_slug )
      .or( top_level_pages
      .where( slug: name_or_slug ) )
      .first ||

      PageSection.default_section&.default_page ||

      Page.top_level_pages.min
  end
end
