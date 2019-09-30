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
      :name, :description, :title, :slug, :section_id, :sort_order, :hidden
    )
  end

  def edit
    # Edit a page section
    @section = PageSection.find( params[:id] )
  end

  def update
    # Save edited page section details
    @section = PageSection.find( params[:id] )

    if @section.update!( section_params )
      flash[ :notice ] = 'Section saved'
    else
      flash[ :error ] = 'Failed to update section details'
    end

    render :edit
  end
end
