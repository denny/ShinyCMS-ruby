# Admin controller for shared content (globally-reusable text/HTML fragments)
class Admin::SharedContentController < AdminController
  # Display form containing all shared content elements
  def index
    @elements = SharedContentElement.order( :name )
  end

  # Add a new shared content element
  def create
    element = SharedContentElement.new( new_element_params )

    if element.save
      flash[ :notice ] = I18n.t 'admin.shared_content.shared_content_created'
    else
      flash[ :alert ] =
        I18n.t 'admin.shared_content.shared_content_create_failed'
    end
    redirect_to admin_shared_content_path
  end

  # Main form submitted; update any changed elements and report back
  def update
    updated_something = false
    updated_something = update_shared_content( updated_something )
    flash[ :notice ] = if updated_something
                         I18n.t 'admin.shared_content.shared_content_updated'
                       else
                         I18n.t 'admin.shared_content.shared_content_unchanged'
                       end
    redirect_to admin_shared_content_path
  end

  # Delete an existing shared content element
  def delete
    if SharedContentElement.destroy( params[ :id ] )
      flash[ :notice ] = I18n.t 'admin.shared_content.shared_content_deleted'
    end
    redirect_to admin_shared_content_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    flash[ :alert ] = I18n.t 'admin.shared_content.shared_content_delete_failed'
    redirect_to admin_shared_content_path
  end

  private

  # Process the batched elements update
  def update_shared_content( flag )
    elements = shared_content_params[ :shared_content ]
    elements&.each_key do |key|
      next unless /element_(?<id>\d+)_content/ =~ key

      content = elements[ "element_#{id}_content" ]
      content_type = elements[ "element_#{id}_content_type" ]

      element = SharedContentElement.find( id )
      next if element.content == content && element.content_type == content_type

      flag = element.update! content: content, content_type: content_type
    end
    flag
  end

  def new_element_params
    params.require( :new_element ).permit( :name, :content, :content_type )
  end

  def shared_content_params
    params.permit( :authenticity_token, :commit, shared_content: {} )
  end
end
