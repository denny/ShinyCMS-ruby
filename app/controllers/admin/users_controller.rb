# Controller for user administration features
class Admin::UsersController < AdminController
  after_action :verify_authorized

  def index
    page_num = params[ :page ] || 1
    @users = User.order( :username ).page( page_num )
    authorise @users
  end

  def new
    @user = User.new
    authorise @user
  end

  def create
    @user = User.new( user_params )
    authorise @user

    if @user.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @user.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit
    @user = User.find( params[:id] )
    authorise @user
  end

  def update
    @user = User.find( params[:id] )
    authorise @user

    if @user.update_without_password( user_params )
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @user.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def delete
    user = User.find( params[:id] )
    authorise user

    flash[ :notice ] = t( '.success' ) if user.destroy
    redirect_to admin_users_path
  rescue ActiveRecord::RecordNotFound, ActiveRecord::NotNullViolation
    redirect_with_alert admin_users_path, t( '.failure' )
  end

  private

  def user_params
    params.require( :user ).permit(
      :username, :email, :password, :display_name, :display_email,
      :profile_pic, :bio, :website, :location, :postcode, :admin_notes,
      capabilities: {}
    )
  end
end
