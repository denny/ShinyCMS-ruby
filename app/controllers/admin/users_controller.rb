# Controller for user administration features
class Admin::UsersController < AdminController
  def index
    @users = User.order( :username )
  end

  def new; end

  def create
    @user = User.new( user_params )

    if @user.save
      flash[ :notice ] = I18n.t 'admin.users.user_created'
      redirect_to action: :edit, id: @user.id
    else
      flash.now[ :alert ] = I18n.t 'admin.users.user_create_failed'
      render action: :new
    end
  end

  def edit
    @user = User.find( params[:id] )
  end

  def update
    @user = User.find( params[:id] )

    if @user.update( user_params )
      flash[ :notice ] = I18n.t 'admin.users.user_updated'
      redirect_to action: :edit, id: @user.id
    else
      flash.now[ :alert ] = I18n.t 'admin.users.user_update_failed'
      render action: :edit
    end
  end

  def delete
    if User.destroy( params[ :id ] )
      flash[ :notice ] = I18n.t 'admin.users.user_deleted'
    end
    redirect_to admin_users_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    flash[ :alert ] = I18n.t 'admin.users.user_delete_failed'
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require( :user ).permit(
      :username, :password, :email, :display_name, :display_email
    )
  end
end
