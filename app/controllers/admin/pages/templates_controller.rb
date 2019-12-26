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
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @template.id
    else
      flash.now[ :alert ] = t( '.failure' )
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
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @template.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render :edit
    end
  end

  def delete
    template = PageTemplate.find( params[:id] )
    authorise template

    flash[ :notice ] = t( '.success' ) if template.destroy
    redirect_to admin_pages_templates_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    handle_delete_exceptions t( '.failure' ),
                             admin_pages_templates_path
  end

  private

  def template_params
    params.require( :page_template ).permit(
      :name, :description, :filename, elements_attributes: {}
    )
  end
end
