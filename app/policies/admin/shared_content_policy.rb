# Pundit policy for shared content admin area
class Admin::SharedContentPolicy < Admin::DefaultPolicy
  attr_reader :user, :record

  def initialize( user, record )
    @user = user
    @record = record
  end

  def index?
    user.can? 'list_shared_content'
  end

  def update?
    user.can? 'edit_shared_content'
  end
end
