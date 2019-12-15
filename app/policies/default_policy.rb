# Default pundit policy for main site
class DefaultPolicy
  attr_reader :this_user, :record

  def initialize( this_user, record )
    @this_user = this_user
    @record = record
  end

  # :nocov:
  def index?
    false
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
  # :nocov:
end
