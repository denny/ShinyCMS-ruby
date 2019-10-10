# Admin controller for page templates
class Admin::Pages::TemplatesController < AdminController
  def index
    # List all templates
    @templates = PageTemplate.all
  end

  def new
    # Add a new template
  end

  def create
    # Save new template details
    @template = PageTemplate.new( template_params )

    if @template.save
      flash[ :notice ] = I18n.t 'template_created'
      redirect_to action: :edit, id: @template.id
    else
      flash.now[ :alert ] = I18n.t 'template_create_failed'
      render action: :new
    end
  end

  def edit
    # Edit a template
    @template = PageTemplate.find( params[:id] )
  end

  def update
    # Save edited template details
    @template = PageTemplate.find( params[:id] )

    if @template.update( template_params )
      flash[ :notice ] = I18n.t 'template_updated'
      redirect_to action: :edit, id: @template.id
    else
      flash.now[ :alert ] = I18n.t 'template_update_failed'
      render :edit
    end
  end

  private

  def template_params
    params.require( :page_template ).permit(
      :name, :description, :filename
    )
  end
end
