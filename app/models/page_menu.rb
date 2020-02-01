# Model to help with generating the Pages section of the main site menu
class PageMenu
  def self.top_level_items
    pages = Page.top_level_menu_pages
    sections = PageSection.top_level_menu_sections

    [ *pages.to_a, *sections.to_a ].sort_by( &:sort_order )
  end
end
