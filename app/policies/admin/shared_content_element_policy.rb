# Pundit policy for elements in shared content admin area
class Admin::SharedContentElementPolicy < Admin::DefaultPolicy
  def create?
    @this_user.can? :add, :shared_content
  end

  def destroy?
    @this_user.can? :destroy, :shared_content
  end
end
