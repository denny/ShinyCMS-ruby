# Admin controller for shared content (globally-reusable text/HTML fragments)
class Admin::SharedContentController < AdminController
  # Display form containing all shared content elements
  def index
    @elements = SharedElement.order( :name )
  end

  # Add a new shared content element
  def create
    element = SharedElement.new( new_element_params )

    if element.save
      flash[ :notice ] = I18n.t 'admin.shared_content.element_created'
    else
      flash[ :alert ] = I18n.t 'admin.shared_content.element_create_failed'
    end
    redirect_to admin_shared_content_path
  end

  # Main form submitted; update any changed elements and report back
  def update
    updated_something = false
    updated_something = update_shared_content( updated_something )
    flash[ :notice ] = if updated_something
                         I18n.t 'admin.shared_content.elements_updated'
                       else
                         I18n.t 'admin.shared_content.elements_unchanged'
                       end
    redirect_to admin_shared_content_path
  end

  # Delete an existing shared content element
  def delete
    if SharedContent.destroy( params[ :id ] )
      flash[ :notice ] = I18n.t 'admin.shared_content.element_deleted'
    end
    redirect_to admin_shared_content_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    flash[ :alert ] = I18n.t 'admin.shared_content.element_delete_failed'
    redirect_to admin_shared_content_path
  end

  private

  # Process the batched elements update
  def update_shared_content( flag )
    elements = shared_content_params[ :elements ]
    elements&.each_key do |key|
      next unless /element_(?<id>\d+)_content/ =~ key

      name = elements[ "element_#{id}_name" ]
      content_type = elements[ "element_#{id}_content_type" ]

      element = SharedElement.find( id )
      next if element.name == name && element.content_type == content_type

      flag = element.update! content: content, content_type: content_type
    end
    flag
  end

  def new_element_params
    params.require( :new_element ).permit( :name, :content, :content_type )
  end

  def shared_content_params
    params.permit( :authenticity_token, :commit, elements: {} )
  end
end
