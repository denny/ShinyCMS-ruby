# Admin controller for page sections
class Admin::Pages::SectionsController < AdminController
  def index
    # Redirect to the combined page+section list
    redirect_to admin_pages_path
  end

  def new
    # Add a new page section
  end

  def create
    # Save new section details
    @section = PageSection.new( section_params )

    if @section.save
      flash[ :notice ] = I18n.t 'admin.pages.section_created'
      redirect_to action: :edit, id: @section.id
    else
      flash.now[ :alert ] = I18n.t 'admin.pages.section_create_failed'
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
      flash[ :notice ] = I18n.t 'admin.pages.section_updated'
      redirect_to action: :edit, id: @section.id
    else
      flash.now[ :alert ] = I18n.t 'admin.pages.section_update_failed'
      render :edit
    end
  end

  def delete
    if PageSection.destroy( params[ :id ] )
      flash[ :notice ] = I18n.t 'admin.pages.section_deleted'
    end
    redirect_to admin_pages_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    flash[ :alert ] = I18n.t 'admin.pages.section_delete_failed'
    redirect_to admin_pages_path
  end

  private

  def section_params
    params.require( :page_section ).permit(
      :name, :description, :title, :slug, :section_id, :sort_order, :hidden
    )
  end
end
