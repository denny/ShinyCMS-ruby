# Pundit policy for shared content admin area
class Admin::SharedContentPolicy < Admin::DefaultPolicy
  def index?
    @this_user.can? :list, :shared_content
  end
end
