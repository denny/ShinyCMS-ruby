# Top-level pundit policy for admin area
class Admin::DefaultPolicy < DefaultPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def index?
    user.admin?
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

  # Add scoping
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
