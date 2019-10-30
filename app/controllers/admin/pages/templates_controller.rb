# Admin controller for page templates
class Admin::Pages::TemplatesController < AdminController
  # List all templates
  def index
    @templates = PageTemplate.all
  end

  def new; end

  def create
    @template = PageTemplate.new( template_params )

    success = false
    success = create_elements if @template.save

    if success
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

  # Create the template elements, based on the contents of the template file
  def create_elements
    dir = %w[ app views pages templates ]
    erb = File.read( Rails.root.join( *dir, "#{@template.filename}.html.erb" ) )
    erb.scan( %r{\@page\.elements\.[a-z][0-9a-z]*}i ).uniq.each do |name|
      name.remove! '@page.elements.'
      return false unless PageTemplateElement.new(
        template_id: @template.id,
        name: name
      ).save
    end
    true
  end

  def template_params
    params.require( :page_template ).permit(
      :name, :description, :filename, elements_attributes: {}
    )
  end
end
