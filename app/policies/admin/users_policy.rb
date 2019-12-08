# Pundit policy for users
class Admin::UsersPolicy < Admin::DefaultPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def index?
    user.can? 'list_users'
  end

  def create?
    user.can? 'add_users'
  end

  def new?
    create?
  end

  def update?
    user.can? 'edit_users'
  end

  def edit?
    update?
  end

  def delete?
    user.can? 'delete_users'
  end
end
