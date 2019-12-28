# Admin controller for page sections
class Admin::Pages::SectionsController < AdminController
  after_action :verify_authorized

  # Redirect to the combined page+section list
  def index
    skip_authorization
    redirect_to pages_path
  end

  def new
    @section = PageSection.new
    authorise @section
  end

  def create
    @section = PageSection.new( section_params )
    authorise @section

    if @section.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @section.id
    else
      flash.now[ :alert ] = t( '.failure' )
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
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @section.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render :edit
    end
  end

  def destroy
    section = PageSection.find( params[:id] )
    authorise section

    flash[ :notice ] = t( '.success' ) if section.destroy
    redirect_to pages_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    redirect_with_alert pages_path, t( '.failure' )
  end

  private

  def section_params
    params.require( :page_section ).permit(
      :name, :description, :title, :slug, :section_id,
      :sort_order, :hidden, :hidden_from_menu
    )
  end
end
