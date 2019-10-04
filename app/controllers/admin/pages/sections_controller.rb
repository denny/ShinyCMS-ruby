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
      flash[ :notice ] = 'New section created'
      redirect_to action: 'edit', id: @section.id
    else
      flash.now[ :alert ] = 'Failed to create new section'
      render action: 'new'
    end
  end

  def edit
    # Edit a page section
    @section = PageSection.find( params[:id] )
  end

  def update
    # Save edited page section details
    @section = PageSection.find( params[:id] )

    if @section.update!( section_params )
      flash.now[ :notice ] = 'Section details updated'
    else
      flash.now[ :alert  ] = 'Failed to update section details'
    end

    render :edit
  end

  private

  def section_params
    params.require( :page_section ).permit(
      :name, :description, :title, :slug, :section_id, :sort_order, :hidden
    )
  end
end
