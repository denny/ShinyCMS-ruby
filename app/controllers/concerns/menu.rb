# Helper methods that will be used across the whole of the main site
module Menu
  extend ActiveSupport::Concern

  included do
    # Populate data used by the menu partial
    def build_menu_data
      @menu_tl_sections = PageSection.top_level_sections
      return unless @page

      if @page.section
        @menu_sections = @page.section.sections
        @menu_pages    = @page.section.pages
      else
        @menu_pages = Page.top_level_pages
      end
    end
  end
end
