# Admin controller for shared content (globally-reusable text/HTML fragments)
class Admin::SharedContentController < AdminController
  def index
    @filenames = SharedContentElement.select_filenames
    elements = SharedContentElement.order( :name )
    @shared_content = SharedContent.new( elements: elements )
  end

  def create
    @new_element = SharedContentElement.new( new_element_params )

    if @new_element.save
      flash[ :notice ] = I18n.t 'admin.shared_content.shared_content_created'
    else
      flash[ :alert ] =
        I18n.t 'admin.shared_content.shared_content_create_failed'
    end
    redirect_to admin_shared_content_path
  end

  # Main form submitted; update any changed elements and report back
  def update
    @shared_content = SharedContent.new
    @shared_content.elements_attributes = shared_content_params

    flash[ :notice ] = if @shared_content.valid?
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

  def new_element_params
    params.require( :new_element ).permit( :name, :content, :content_type )
  end

  def shared_content_params
    params.permit( :authenticity_token, :commit, elements: {} )
  end
end
