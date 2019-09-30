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
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def template_params
    params.require( :page_template ).permit(
      :name, :description, :filename
    )
  end

  def edit
    # Edit a template
    @template = PageTemplate.find( params[:id] )
  end

  def update
    # Save edited template details
    @template = PageTemplate.find( params[:id] )

    if @template.update!( template_params )
      flash[ :notice ] = 'Template saved'
    else
      flash[ :error ] = 'Failed to update template details'
    end

    render :edit
  end
end
