# Pundit policy for shared content admin area
class Admin::SharedContentPolicy < Admin::DefaultPolicy
  def index?
    @record = [ @record ]

    super
  end
end
