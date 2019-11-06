# Admin controller for CMS-controlled 'brochure' pages
class Admin::PagesController < AdminController
  def index
    # List all pages
    @tl_pages = Page.top_level_pages + Page.top_level_hidden_pages
    @tl_sections =
      PageSection.top_level_sections + PageSection.top_level_hidden_sections
  end

  def new; end

  def create
    @page = Page.new( page_params )

    if @page.save
      flash[ :notice ] = I18n.t 'admin.pages.page_created'
      redirect_to action: :edit, id: @page.id
    else
      flash.now[ :alert ] = I18n.t 'admin.pages.page_create_failed'
      render action: :new
    end
  end

  def edit
    @filenames = PageElement.select_filenames
    @page = Page.find( params[:id] )
  end

  def update
    @page = Page.find( params[:id] )

    if @page.update( page_params )
      flash[ :notice ] = I18n.t 'admin.pages.page_updated'
      redirect_to action: :edit, id: @page.id
    else
      flash.now[ :alert ] = I18n.t 'admin.pages.page_update_failed'
      @filenames = PageElement.select_filenames
      render action: :edit
    end
  end

  private

  def page_params
    params.require( :page ).permit(
      :name, :description, :title, :slug,
      :template_id, :section_id, :sort_order, :hidden, elements_attributes: {}
    )
  end
end
