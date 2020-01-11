# Pundit policy for inserts (prev: 'shared content')
class Admin::InsertElementPolicy < Admin::DefaultPolicy
  def create?
    @this_user.can? :add, :inserts
  end

  def destroy?
    @this_user.can? :destroy, :inserts
  end
end
