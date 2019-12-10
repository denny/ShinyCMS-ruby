# Top-level pundit policy for admin area
class Admin::DefaultPolicy < DefaultPolicy
  attr_reader :user, :record

  # :nocov:
  def initialize( user, record )
    @user = user
    @record = record
  end

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
  # :nocov:
end
