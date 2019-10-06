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
      flash[ :notice ] = 'New template created'
      redirect_to action: :edit, id: @template.id
    else
      flash[ :alert  ] = 'Failed to create new template'
      redirect_to action: :new
    end
  end

  def edit
    # Edit a template
    @template = PageTemplate.find( params[:id] )
  end

  def update
    # Save edited template details
    @template = PageTemplate.find( params[:id] )

    _unused = @template.update( template_params )
    if @template.valid?
      flash[ :notice ] = 'Template details updated'
    else
      flash[ :alert  ] = 'Failed to update template details'
    end

    redirect_to action: :edit, id: @template.id
  end

  private

  def template_params
    params.require( :page_template ).permit(
      :name, :description, :filename
    )
  end
end
