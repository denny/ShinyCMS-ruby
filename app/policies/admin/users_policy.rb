# Pundit policy for users
class Admin::UsersPolicy < Admin::DefaultPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def index?
    user.admin? # && user.has_permission( 'list_users' )
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
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
