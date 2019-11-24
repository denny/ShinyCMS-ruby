# Admin controller for page templates
class Admin::Pages::TemplatesController < AdminController
  # List all templates
  def index
    page_num = params[ :page ] || 1
    @templates = PageTemplate.order( :name ).page( page_num )
  end

  def new; end

  def create
    @template = PageTemplate.new( template_params )

    if @template.save
      flash[ :notice ] = I18n.t 'admin.pages.template_created'
      redirect_to action: :edit, id: @template.id
    else
      flash.now[ :alert ] = I18n.t 'admin.pages.template_create_failed'
      render action: :new
    end
  end

  def edit
    @template = PageTemplate.find( params[:id] )
  end

  def update
    @template = PageTemplate.find( params[:id] )

    if @template.update( template_params )
      flash[ :notice ] = I18n.t 'admin.pages.template_updated'
      redirect_to action: :edit, id: @template.id
    else
      flash.now[ :alert ] = I18n.t 'admin.pages.template_update_failed'
      render :edit
    end
  end

  def delete
    if PageTemplate.destroy( params[ :id ] )
      flash[ :notice ] = I18n.t 'admin.pages.template_deleted'
    end
    redirect_to admin_pages_templates_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    flash[ :alert ] = I18n.t 'admin.pages.template_delete_failed'
    redirect_to admin_pages_templates_path
  end

  private

  def template_params
    params.require( :page_template ).permit(
      :name, :description, :filename, elements_attributes: {}
    )
  end
end
