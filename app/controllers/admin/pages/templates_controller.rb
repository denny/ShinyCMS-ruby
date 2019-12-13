# Admin controller for page templates
class Admin::Pages::TemplatesController < AdminController
  after_action :verify_authorized

  def index
    authorise PageTemplate

    page_num = params[ :page ] || 1

    @templates = PageTemplate.order( :name ).page( page_num )
    authorise @templates if @templates.present?
  end

  def new
    @template = PageTemplate.new
    authorise @template
  end

  def create
    @template = PageTemplate.new( template_params )
    authorise @template

    if @template.save
      flash[ :notice ] = t( 'template_created' )
      redirect_to action: :edit, id: @template.id
    else
      flash.now[ :alert ] = t( 'template_create_failed' )
      render action: :new
    end
  end

  def edit
    @template = PageTemplate.find( params[:id] )
    authorise @template
  end

  def update
    @template = PageTemplate.find( params[:id] )
    authorise @template

    if @template.update( template_params )
      flash[ :notice ] = t( 'template_updated' )
      redirect_to action: :edit, id: @template.id
    else
      flash.now[ :alert ] = t( 'template_update_failed' )
      render :edit
    end
  end

  def delete
    template = PageTemplate.find( params[:id] )
    authorise template

    flash[ :notice ] = t( 'template_deleted' ) if template.destroy
    redirect_to admin_pages_templates_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    handle_delete_exceptions t( 'template_delete_failed' ),
                             admin_pages_templates_path
  end

  private

  def template_params
    params.require( :page_template ).permit(
      :name, :description, :filename, elements_attributes: {}
    )
  end

  def t( key )
    I18n.t( "admin.pages.#{key}" )
  end
end
