# Admin controller for inserts (globally-reusable text/HTML fragments)
class Admin::InsertsController < AdminController
  after_action :verify_authorized

  # Displays main form, for updating/deleting the existing insert,
  # and a second form at the bottom of the page to add new insert.
  def index
    @insert_set = InsertSet.first
    authorise @insert_set
  end

  # Bottom of page form submitted; add new insert
  def create
    @new_element = InsertSet.first.elements.new( new_element_params )
    authorise @new_element

    if @new_element.save
      flash[ :notice ] = t( '.success' )
    else
      flash[ :alert ] = t( '.failure' )
    end
    redirect_to inserts_path
  end

  # Main form submitted; update existing insert
  def update
    @insert_set = InsertSet.first
    authorise @insert_set

    flash[ :notice ] = t( '.success' ) if @insert_set.update( insert_params )
    redirect_to action: :index
  rescue ActiveRecord::RecordNotUnique
    skip_authorization
    redirect_with_alert inserts_path, t( '.failure' )
  end

  def destroy
    element = InsertElement.find( params[ :id ] )
    authorise element

    flash[ :notice ] = t( '.success' ) if element.destroy
    redirect_to inserts_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    redirect_with_alert inserts_path, t( '.failure' )
  end

  private

  # Permitted params for single-item operations
  def new_element_params
    params.require( :insert_element )
          .permit( :name, :content, :content_type )
  end

  # Permitted params for multi-item operations
  def insert_params
    params.require( :insert_set ).permit( elements_attributes: {} )
  end
end
