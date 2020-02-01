# Model to help with generating the Pages section of the main site menu
class PageMenu
  def self.top_level_items
    pages = Page.top_level_menu_pages.to_a
    sections = PageSection.top_level_menu_sections.to_a

    [ *pages, *sections ].sort_by( &:sort_order )
  end
end
