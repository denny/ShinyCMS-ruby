# Model for 'brochure' pages
class Page < ApplicationRecord
  # Associations
  belongs_to :section,  class_name: 'PageSection', optional: true,
                        inverse_of: 'pages'
  belongs_to :template, class_name: 'PageTemplate',
                        inverse_of: 'pages'

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

  def self.default_page
    # TODO
    # 1.  Page.find( Config.default_page )
    # 2.  Section.find( Config.default_section )
    # 2a. default_section.pages.default_page
    # 2b. default_section.pages.first

    return Page.top_level_pages.first if Page.top_level_pages.first

    Page.first
  end
end
