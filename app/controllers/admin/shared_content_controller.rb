# Admin controller for shared content (globally-reusable text/HTML fragments)
class Admin::SharedContentController < AdminController
  after_action :verify_authorized

  # Displays main form, for updating/deleting the existing shared content,
  # and a second form at the bottom of the page to add new shared content.
  def index
    elements = SharedContentElement.order( :name )
    @shared_content = SharedContent.new( elements: elements )

    authorise @shared_content
  end

  # Bottom of page form submitted; add new shared content
  def create
    @new_element = SharedContentElement.new( new_element_params )

    authorise @new_element

    if @new_element.save
      flash[ :notice ] = t( '.shared_content_created' )
    else
      flash[ :alert ] = t( '.shared_content_create_failed' )
    end
    redirect_to admin_shared_content_path
  end

  # Main form submitted; update existing shared content
  def update
    elements = SharedContentElement.order( :name )
    @shared_content = SharedContent.new( elements: elements )

    authorise @shared_content

    @shared_content.elements_attributes = shared_content_params

    if @shared_content.valid?
      flash[ :notice ] = t( '.shared_content_updated' )
    else
      flash[ :alert ] = t( '.shared_content_update_failed' )
    end
    redirect_to admin_shared_content_path
  end

  def delete
    element = SharedContentElement.find( params[ :id ] )

    authorise element

    flash[ :notice ] = t( '.shared_content_deleted' ) if element.destroy
    redirect_to admin_shared_content_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    handle_delete_exceptions t( '.shared_content_delete_failed' ),
                             admin_shared_content_path
  end

  private

  # Permitted params for single-item operations
  def new_element_params
    params.require( :shared_content_element )
          .permit( :name, :content, :content_type )
  end

  # Permitted params for multi-item operations
  def shared_content_params
    params.require( :shared_content ).permit( elements_attributes: {} )
          .require( :elements_attributes )
  end
end
