# Admin controller for page sections
class Admin::Pages::SectionsController < AdminController
  after_action :verify_authorized

  def index
    authorise Page
    # Redirect to the combined page+section list
    redirect_to admin_pages_path
  end

  def new
    @section = PageSection.new
    authorise @section
  end

  def create
    @section = PageSection.new( section_params )
    authorise @section

    if @section.save
      flash[ :notice ] = t( 'section_created' )
      redirect_to action: :edit, id: @section.id
    else
      flash.now[ :alert ] = t( 'section_create_failed' )
      render action: :new
    end
  end

  def edit
    @section = PageSection.find( params[:id] )
    authorise @section
  end

  def update
    @section = PageSection.find( params[:id] )
    authorise @section

    if @section.update( section_params )
      flash[ :notice ] = t( 'section_updated' )
      redirect_to action: :edit, id: @section.id
    else
      flash.now[ :alert ] = t( 'section_update_failed' )
      render :edit
    end
  end

  def delete
    section = PageSection.find( params[:id] )
    authorise section

    flash[ :notice ] = t( 'section_deleted' ) if section.destroy
    redirect_to admin_pages_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    handle_delete_exceptions
  end

  private

  def section_params
    params.require( :page_section ).permit(
      :name, :description, :title, :slug, :section_id,
      :sort_order, :hidden, :hidden_from_menu
    )
  end

  def handle_delete_exceptions
    flash[ :alert ] = t( 'section_delete_failed' )
    redirect_to admin_pages_path
  end

  def t( key )
    I18n.t( "admin.pages.#{key}" )
  end
end
