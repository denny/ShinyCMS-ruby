# Pundit policy for users
class Admin::UsersPolicy < Admin::DefaultPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def index?
    user.can( I18n.t( 'capability.list_users' ) )
  end

  def show?
    false
  end

  def create?
    user.can( I18n.t( 'capability.add_users' ) )
  end

  def new?
    create?
  end

  def update?
    user.can( I18n.t( 'capability.edit_users' ) )
  end

  def edit?
    update?
  end

  def delete?
    user.can( I18n.t( 'capability.delete_users' ) )
  end

  # Add scoping to the top-level pundit policy
  class Scope
    attr_reader :user, :scope

    def initialize( user, scope )
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
