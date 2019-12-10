# Admin controller for shared content (globally-reusable text/HTML fragments)
class Admin::SharedContentController < AdminController
  after_action :verify_authorized

  # Display the main form, containing all shared content ready to edit
  def index
    elements = SharedContentElement.order( :name )
    @shared_content = SharedContent.new( elements: elements )

    authorise @shared_content
  end

  def create
    @new_element = SharedContentElement.new( new_element_params )

    authorise @new_element

    if @new_element.save
      flash[ :notice ] = t( 'shared_content_created' )
    else
      flash[ :alert ] = t( 'shared_content_create_failed' )
    end
    redirect_to admin_shared_content_path
  end

  # Main form submitted; update any changed elements and report back
  def update
    elements = SharedContentElement.order( :name )
    @shared_content = SharedContent.new( elements: elements )

    authorise @shared_content

    @shared_content.elements_attributes = shared_content_params

    flash[ :notice ] = t( 'shared_content_updated' )
    redirect_to admin_shared_content_path
  end

  def delete
    element = SharedContentElement.find( params[ :id ] )

    authorise element

    flash[ :notice ] = t( 'shared_content_deleted' ) if element.destroy
    redirect_to admin_shared_content_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    handle_delete_exceptions
  end

  private

  def new_element_params
    params.require( :shared_content_element )
          .permit( :name, :content, :content_type )
  end

  def shared_content_params
    params.require( :shared_content ).permit( elements_attributes: {} )
          .require( :elements_attributes )
  end

  def handle_delete_exceptions
    flash[ :alert ] = t( 'shared_content_delete_failed' )
    redirect_to admin_shared_content_path
  end

  def t( key )
    I18n.t( "admin.shared_content.#{key}" )
  end
end
