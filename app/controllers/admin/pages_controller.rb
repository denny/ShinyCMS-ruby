# Admin controller for CMS-controlled 'brochure' pages
class Admin::PagesController < AdminController
  def index
    # List all pages
    @tl_pages = Page.top_level_pages
    @tl_sections = PageSection.top_level_sections
  end

  def new
    # Add a new page
  end

  def create
    # Save new page details
  end

  def edit
    # Edit a page
  end

  def update
    # Save edited page details
  end
end
