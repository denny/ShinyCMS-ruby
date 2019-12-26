# Menu helper methods, for use across the whole of the main site
module MainSiteMenuHelper
  # Populate data used by the menu partial
  def build_menu_data( section = nil )
    menu = {}

    menu[ :pages ] = {}
    menu[ :pages ][ :top_sections ] = PageSection.top_level_menu_sections
    menu[ :pages ][ :top_pages    ] = Page.top_level_menu_pages
    return menu unless section

    menu[ :pages ][ :sections ] = section.sections
                                         .where( hidden_from_menu: false )
    menu[ :pages ][ :pages    ] = section.pages.where( hidden_from_menu: false )

    menu
  end
end
