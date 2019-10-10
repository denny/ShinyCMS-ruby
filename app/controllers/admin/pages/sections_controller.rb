# Admin controller for page sections
class Admin::Pages::SectionsController < AdminController
  before_action :check_admin_ip_whitelist

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
      flash[ :notice ] = I18n.t 'section_created'
      redirect_to action: :edit, id: @section.id
    else
      flash.now[ :alert ] = I18n.t 'section_create_failed'
      render action: :new
    end
  end

  def edit
    # Edit a page section
    @section = PageSection.find( params[:id] )
  end

  def update
    # Save edited page section details
    @section = PageSection.find( params[:id] )

    if @section.update( section_params )
      flash[ :notice ] = I18n.t 'section_updated'
      redirect_to action: :edit, id: @section.id
    else
      flash.now[ :alert ] = I18n.t 'section_update_failed'
      render :edit
    end
  end

  private

  def section_params
    params.require( :page_section ).permit(
      :name, :description, :title, :slug, :section_id, :sort_order, :hidden
    )
  end
end
