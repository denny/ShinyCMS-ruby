# Admin controller for page sections
class Admin::Pages::SectionsController < AdminController
  def index
    # List all page sections
    @tl_sections = PageSection.top_level_sections
  end

  def new
    # Add a new page section
  end

  def create
    # Save new section details
    @section = PageSection.new( section_params )

    if @section.save
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def section_params
    params.require( :page_section ).permit(
      :name, :description, :title, :slug, :section
    )
  end

  def edit
    # Edit a page section
  end

  def update
    # Save edited page section details
  end
end
