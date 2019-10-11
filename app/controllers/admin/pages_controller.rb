# Admin controller for CMS-controlled 'brochure' pages
class Admin::PagesController < AdminController
  before_action :check_admin_ip_whitelist

  def index
    # List all pages
    @tl_pages = Page.top_level_pages + Page.top_level_hidden_pages
    @tl_sections =
      PageSection.top_level_sections + PageSection.top_level_hidden_sections
  end

  def new
    # Add a new page
  end

  def create
    # Save new page details
    @page = Page.new( page_params )

    if @page.save
      flash[ :notice ] = I18n.t 'page_created'
      redirect_to action: :edit, id: @page.id
    else
      flash.now[ :alert ] = I18n.t 'page_create_failed'
      render action: :new
    end
  end

  def edit
    # Edit a page
    @page = Page.find( params[:id] )
  end

  def update
    # Save edited page details
    @page = Page.find( params[:id] )

    if @page.update( page_params )
      flash[ :notice ] = I18n.t 'page_updated'
      redirect_to action: :edit, id: @page.id
    else
      flash.now[ :alert ] = I18n.t 'page_update_failed'
      render action: :edit
    end
  end

  private

  def page_params
    params.require( :page ).permit(
      :name, :description, :title, :slug,
      :template_id, :section_id, :sort_order, :hidden
    )
  end
end
