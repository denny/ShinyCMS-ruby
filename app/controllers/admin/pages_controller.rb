# Admin controller for CMS-controlled 'brochure' pages
class Admin::PagesController < AdminController
  def index
    authorise Page
    # authorise PageSection

    @tl_pages = Page.top_level_pages + Page.top_level_hidden_pages
    authorise @tl_pages if @tl_pages.present?

    @tl_sections =
      PageSection.top_level_sections + PageSection.top_level_hidden_sections
    authorise @tl_sections if @tl_sections.present?
  end

  def new
    @page = Page.new
    authorise @page
  end

  def create
    @page = Page.new( page_params )
    authorise @page

    if @page.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @page.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit
    @page = Page.find( params[:id] )
    authorise @page
  end

  def update
    @page = Page.find( params[:id] )
    authorise @page

    if @page.update( page_params )
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @page.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def destroy
    page = Page.find( params[:id] )
    authorise page

    flash[ :notice ] = t( '.success' ) if page.destroy
    redirect_to pages_path
  rescue ActiveRecord::RecordNotFound, ActiveRecord::NotNullViolation
    redirect_with_alert pages_path, t( '.failure' )
  end

  private

  def page_params
    params.require( :page ).permit(
      :name, :description, :title, :slug, :template_id, :section_id,
      :sort_order, :hidden, :hidden_from_menu,
      elements_attributes: {}
    )
  end
end
