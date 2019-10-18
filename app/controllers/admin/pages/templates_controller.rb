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
      flash[ :notice ] = I18n.t 'template_created'
      redirect_to action: :edit, id: @template.id
    else
      flash.now[ :alert ] = I18n.t 'template_create_failed'
      render action: :new
    end
  end

  def edit
    @template = PageTemplate.find( params[:id] )
  end

  def update
    @template = PageTemplate.update( params[:id], template_params )
    success = update_elements if @template.valid?

    if success
      flash[ :notice ] = I18n.t 'template_updated'
      redirect_to action: :edit, id: @template.id
    else
      flash.now[ :alert ] = I18n.t 'template_update_failed'
      render :edit
    end
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

  # Update the elements
  def update_elements
    new_elements = template_params[ :elements ]
    new_elements&.each_key do |key|
      next unless /element_(?<id>\d+)_name/ =~ key

      name = new_elements[ "element_#{id}_name" ]
      type = new_elements[ "element_#{id}_type" ]

      element = PageTemplateElement.find( id )
      next if element.name == name && element.type == type

      return false unless element.update name: name, type: type
    end
    true
  end

  def template_params
    params.require( :page_template ).permit(
      :name, :description, :filename, :elements
    )
  end
end
