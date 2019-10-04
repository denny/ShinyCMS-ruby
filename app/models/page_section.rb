# Model for page sections
class PageSection < ApplicationRecord
  has_many  :pages,
            -> { where( hidden: false ).order( :sort_order ) },
            foreign_key: 'section_id', inverse_of: 'section'

  has_many  :hidden_pages,
            -> { where( hidden: true ).order( :sort_order ) },
            class_name: 'Page',
            foreign_key: 'section_id', inverse_of: 'section'

  has_many  :sections,
            -> { where( hidden: false ).order( :sort_order ) },
            class_name: 'PageSection',
            foreign_key: 'section_id', inverse_of: 'section'

  belongs_to  :section,
              class_name: 'PageSection',
              optional: true, inverse_of: 'sections'

  # Instance methods

  # Return the default page for this section if one is set
  # If the default isn't set, return the first page in this section
  def default_page
    return pages.find self[ :default_page_id ] if self[ :default_page_id ]

    pages.first
  end

  # Returns true if there is a page in this section or in any of its descendants
  def tree_contains_pages?
    return true if pages.any?

    sections.each do |section|
      yarp = section.tree_contains_pages?
      return true if yarp
    end

    false
  end

  # Class methods

  def self.top_level_sections
    PageSection.where( section: nil )
  end

  # Return the default top-level section
  def self.default_section
    PageSection.first
  end
end
